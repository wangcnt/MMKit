//
//  MMConnection.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/23.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMConnection.h"

#import "MMRequest.h"
#import "MMResponse.h"
#import "MMOperation.h"
#import <MMLog/MMLog.h>
#import "MMApplication.h"
#import "MMSessionManager.h"
#import "MMRequestIDGenerator.h"
#import "MMSessionConfiguration.h"
#import <MMFoundation/MMDefines.h>
#import <MMFoundation/GCDAsyncSocket.h>

MMSocketConnectionIdentifier const MMSocketConnectionDefaultIdentifier = @"Default";
MMSocketConnectionIdentifier const MMSocketConnectionFreeIdentifier = @"Free";

static NSString *const MMSocketUserInfoDisconnectedByUserKey = @"MMSocketUserInfoDisconnectedByUserKey";

typedef enum : NSUInteger {
    MMSocketRequestStatusWaiting,
    MMSocketRequestStatusGoing,
    MMSocketRequestStatusCancelled,
    MMSocketRequestStatusFinished
} MMSocketRequestStatus;

@interface MMSocketRequestWrapper : NSObject
@property (nonatomic, strong) id<MMSocketRequest> request;
@property (nonatomic, copy) MMRequestCompletion completion;
@property (nonatomic, assign) MMSocketRequestStatus status;
@end

@implementation MMSocketRequestWrapper
@end

@implementation MMConnection
- (void)cancelAllRequestsWithError:(NSError *)error {
}

- (void)cancelRequest:(id<MMRequest>)request withError:(NSError *)error {
}

- (void)sendRequest:(id<MMRequest>)request withCompletion:(MMRequestCompletion)completion {
}

@end

@implementation MMHTTPConnection
@end

@interface MMSocketConnection ()
<GCDAsyncSocketDelegate> {
    GCDAsyncSocket *_socket;
    dispatch_semaphore_t _semaphore;
    dispatch_source_t _pingTimer;
    NSInteger _maxPingTimes;
    NSInteger _pingTimes;
    NSMutableDictionary<NSString *, MMSocketRequestWrapper *> *_wrapperDictionary;    ///< 請求緩存，方便讀取
    NSMutableArray<MMSocketRequestWrapper *> *_wrapperArray;
}
@property (nonatomic, assign, readonly) BOOL connected;
@property (nonatomic, assign, readonly) BOOL connecting;
@property (nonatomic, strong) dispatch_source_t pingTimer;
@end

@implementation MMSocketConnection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(1);
        
        dispatch_queue_t delegate_queue = dispatch_queue_create("com.markwong.mmcoreservices.connection.socket.delegatequeue", DISPATCH_QUEUE_SERIAL);
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:delegate_queue];
        
        _identifier = MMSocketConnectionDefaultIdentifier;
        
        _pingInterval = 5;
        _maxPingTimes = 7;
        
        _wrapperDictionary = [NSMutableDictionary<NSString *, MMSocketRequestWrapper *> dictionaryWithCapacity:5];
        _wrapperArray = [NSMutableArray<MMSocketRequestWrapper *> arrayWithCapacity:5];
    }
    return self;
}

- (void)setIdentifier:(NSString *)identifier {
    if(_identifier != identifier) {
        _identifier = identifier;
        _type = ([MMSocketConnectionDefaultIdentifier isEqualToString:_identifier] ? MMSocketConnectionTypeDefault :
                 [MMSocketConnectionFreeIdentifier isEqualToString:_identifier] ? MMSocketConnectionTypeFree :
                 MMSocketConnectionTypeGroup);
    }
}

- (void)connect {
    if(self.connected || self.connecting) {
        return;
    }
    if(!_host.length || _port<=0 || _port>65536) {
        MMLogInfo(@"connect failed with host:%@, port:%d", _host, _port);
        return;
    }
    
    NSError *error;
    [_socket connectToHost:_host onPort:_port error:&error];
    if(error) {
        MMLogInfo(@"connect failed with error:%@", error);
    }
}

- (void)disconnect {
    _socket.userData = @{MMSocketUserInfoDisconnectedByUserKey : @YES};
    [_socket disconnect];
}

- (id<MMSocketResponse>)responseForRequest:(id<MMSocketRequest>)request {
    Class clazz = (Class)request.responseClass;
    id<MMSocketResponse> response = [[clazz alloc] init];
    response.request = request;
    return response;
}

- (void)finishWithCompletion:(MMRequestCompletion)completion response:(id<MMSocketResponse>)response {
    __mm_dispatch_async__(completion, response.request.configuration.database_queue, response);
}

- (void)sendRequest:(id<MMSocketRequest>)request withCompletion:(MMRequestCompletion)completion {
    void (^saveRequestAndSendOrNot)(BOOL) = ^ (BOOL shouldSend) {
        MMSocketRequestWrapper *wrapper = [[MMSocketRequestWrapper alloc] init];
        wrapper.request = request;
        wrapper.completion = completion;
        
        id<MMRequestIDGenerator> idGenerator = request.configuration.requestIDGenerator;
        request.identifier = idGenerator.nextID;
        
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        _wrapperDictionary[request.identifier] = wrapper;
        [_wrapperArray addObject:wrapper];
        dispatch_semaphore_signal(_semaphore);

        if(shouldSend) {
            [self sendRequest:request];
        }
    };
    
    if(!self.connected) {
        [self connect];
    }
    
    saveRequestAndSendOrNot(self.connected);
}

- (void)sendRequest:(id<MMSocketRequest>)request {
    MMSocketRequestWrapper *wrapper = _wrapperDictionary[request.identifier];
    if(wrapper.status == MMSocketRequestStatusWaiting) {
        //TODO: 超時定時器
        
        wrapper.status = MMSocketRequestStatusGoing;
        [_socket writeData:request.payload withTimeout:request.timeoutInterval tag:1];
    }
}

- (NSError *)errorForCancelledRequest:(id<MMSocketRequest>)request {
    return [NSError errorWithDomain:MMCoreServicesErrorDomain
                               code:MMCoreServicesErrorCodeRequestCancelled
                           userInfo:@{NSLocalizedDescriptionKey : @"Request was cancelled.",
                                      @"request" : request.command}];
}

- (void)cancelRequest:(id<MMSocketRequest>)request withError:(NSError *)error {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    MMSocketRequestWrapper *wrapper = _wrapperDictionary[request.identifier];
    if(wrapper) {
        wrapper.status = MMSocketRequestStatusCancelled;
        if(wrapper.completion) {
            id<MMSocketResponse> response = [self responseForRequest:request];
            response.error = error;
            [self finishWithCompletion:wrapper.completion response:response];
        }
    }
    [_wrapperArray removeObject:request];
    [_wrapperDictionary removeObjectForKey:request.identifier];
    
    dispatch_semaphore_signal(_semaphore);
}

- (void)cancelAllRequestsWithError:(NSError *)error {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    for(id<MMSocketRequest> request in _wrapperArray) {
        MMSocketRequestWrapper *wrapper = _wrapperDictionary[request.identifier];
        if(wrapper) {
            wrapper.status = MMSocketRequestStatusCancelled;
            if(wrapper.completion) {
                id<MMSocketResponse> response = [self responseForRequest:request];
                response.error = error;
                [self finishWithCompletion:wrapper.completion response:response];
            }
        }
    }
    
    [_wrapperDictionary removeAllObjects];
    [_wrapperArray removeAllObjects];
    
    dispatch_semaphore_signal(_semaphore);
}

- (void)startPing {
    if(_pingTimer) return;
    
    _pingTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_pingTimer, dispatch_walltime(NULL, 0), _pingInterval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_pingTimer, ^{
        if(_pingTimes++ < _maxPingTimes) {
            [self connect];
        } else {
            [self stopPing];
        }
    });
    dispatch_source_set_cancel_handler(_pingTimer, ^{
        _pingTimes = 0;
        _pingTimer = nil;
    });
}

- (void)stopPing {
    if(!_pingTimer) return;
    dispatch_source_cancel(_pingTimer);
}

- (void)dealloc {
    _socket.delegate = nil;
    [self stopPing];
}

#pragma mark -------------------------------------------------------------------
#pragma mark GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    _connected = YES;
    _connecting = NO;
    
    [self stopPing];
    
    [sock readDataWithTimeout:0 tag:2];
    
    // 自動發動緩存的請求
    for(MMSocketRequestWrapper *wrapper in _wrapperArray) {
        if(wrapper.status == MMSocketRequestStatusWaiting) {
            [self sendRequest:wrapper.request];
        }
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    BOOL disconnectedByUser = NO;
    if([sock.userData isKindOfClass:NSDictionary.class]) {
        disconnectedByUser = [sock.userData[MMSocketUserInfoDisconnectedByUserKey] boolValue];
    }
    if(disconnectedByUser) {
        [self stopPing];
    } else {
        _connecting = (_pingTimer && _pingTimes < _maxPingTimes);
    }
    
    _loginStatus = MMSocketConnectionLoginStatusTraveller;
    _connected = NO;
    NSString *message = [NSString stringWithFormat:@"Socket closed by %@", disconnectedByUser ? @"user" : @"server"];
    NSError *error = [NSError errorWithDomain:MMCoreServicesErrorDomain code:MMCoreServicesErrorCodeRequestCancelled userInfo:@{NSLocalizedDescriptionKey : message}];
    [self cancelAllRequestsWithError:error];
    
    if(!disconnectedByUser && _type==MMSocketConnectionTypeDefault) {
        [self startPing];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [sock readDataWithTimeout:0 tag:2];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //FIXME: how to find the original MMSocketRequest?
    [_buffer appendData:data];
    id<MMSocketResponse> response;
    [response receiveData:data];
}

@synthesize manager = _manager;
@synthesize pingInterval = _pingInterval;
@synthesize status = _status;
@synthesize type = _type;
@synthesize loginStatus = _loginStatus;
@synthesize buffer = _buffer;
@synthesize host = _host;
@synthesize identifier = _identifier;
@synthesize port = _port;

@end
