//
//  MMConnection.m
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/23.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "MMConnection.h"

#import "MMRequest.h"
#import "MMResponse.h"
#import "MMSessionManager.h"
#import "GCDAsyncSocket.h"

NSString *const MMSocketConnectionDefaultIdentifier = @"Default";
NSString *const MMSocketConnectionFreeIdentifier = @"Free";
static NSString *const MMSocketUserInfoDisconnectedByUserKey = @"MMSocketUserInfoDisconnectedByUserKey";

typedef enum : NSUInteger {
    MMSocketRequestStatusWaiting,
    MMSocketRequestStatusGoing,
    MMSocketRequestStatusCancelled,
    MMSocketRequestStatusFinished
} MMSocketRequestStatus;

@interface MMSocketRequestWrapper : NSObject
@property (nonatomic, strong) id<MMSocketRequest> request;
@property (nonatomic, strong) MMRequestCompletion completion;
@property (nonatomic, assign) MMSocketRequestStatus status;
@end

@implementation MMSocketRequestWrapper
@end

@implementation MMConnection

@end

@interface MMSocketConnection ()
<GCDAsyncSocketDelegate> {
    GCDAsyncSocket *_socket;
    dispatch_semaphore_t _semaphore;
    dispatch_source_t _pingTimer;
    NSInteger _maxPingTimes;
    NSInteger _pingTimes;
    NSMutableDictionary<NSString *, MMSocketRequestWrapper *> *_wrapperDictionary;    ///< 請求緩存，方便讀取
    NSMutableArray<MMSocketRequestWrapper *> *_wrapperArray;  ///< 請求隊列，序列執行
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
        NSLog(@"connect failed with host:%@, port:%d", _host, _port);
        return;
    }
    
    NSError *error;
    [_socket connectToHost:_host onPort:_port error:&error];
    if(error) {
        NSLog(@"connect failed with error:%@", error);
    }
}

- (void)disconnect {
    _socket.userData = @{MMSocketUserInfoDisconnectedByUserKey : @YES};
    [_socket disconnect];
}

- (void)callbackWithCompletion:(MMRequestCompletion)completion response:(id<MMSocketResponse>)response {
    if(completion) {
        if(_completion_queue) {
            dispatch_async(self.completion_queue, ^{
                completion(response);
            });
        } else {
            completion(response);
        }
    }
}

- (void)sendRequest:(id<MMSocketRequest>)request withCompletion:(MMRequestCompletion)completion {
    void (^saveRequestAndSaveOrNot)(BOOL) = ^ (BOOL shouldSend) {
        MMSocketRequestWrapper *wrapper = [[MMSocketRequestWrapper alloc] init];
        wrapper.request = request;
        wrapper.completion = completion;
        
        NSAssert(request.taskIdentifier, @"request.identifier must not be nil.");
        _wrapperDictionary[request.taskIdentifier] = wrapper;
        [_wrapperArray addObject:wrapper];

        if(shouldSend) {
            [self sendRequest:request];
        }
    };
    
    if(_connected) {
        if(_type == MMSocketConnectionTypeFree) {
            saveRequestAndSaveOrNot(YES);
        } else {
            if(_loginStatus == MMSocketConnectionLoginStatusLogined) {
                if(request.type == MMRequestTypeLogin) {
                    Class clazz = (Class)request.responseClass;
                    id<MMSocketResponse> response = [[clazz alloc] init];
                    response.logined = YES;
                    [self callbackWithCompletion:completion response:response];
                } else {
                    saveRequestAndSaveOrNot(YES);
                }
            } else if(_loginStatus == MMSocketConnectionLoginStatusLogining) {
                if(request.type == MMRequestTypeLogin) {
                    Class clazz = (Class)request.responseClass;
                    id<MMSocketResponse> response = [[clazz alloc] init];
                    response.logining = YES;
                    [self callbackWithCompletion:completion response:response];
                } else {
                    // 登錄成功自動發送
                    saveRequestAndSaveOrNot(NO);
                }
            } else {
                if(_manager.autologinHandler) {
                    saveRequestAndSaveOrNot(NO);
                    _manager.autologinHandler(_identifier);
                } else {
                    NSError *error = [NSError errorWithDomain:@"com.markwong.mmcoreservices." code:111 userInfo:@{NSLocalizedDescriptionKey : @"Please login first."}];
                    Class clazz = (Class)request.responseClass;
                    id<MMSocketResponse> response = [[clazz alloc] init];
                    response.error = error;
                    [self callbackWithCompletion:completion response:response];
                }
            }
        }
    } else {
        saveRequestAndSaveOrNot(NO);
        [self connect];
    }
}

- (void)sendRequest:(id<MMSocketRequest>)request {
    MMSocketRequestWrapper *wrapper = _wrapperDictionary[request.taskIdentifier];
    if(wrapper.status == MMSocketRequestStatusWaiting) {
        //TODO: 超時定時器
        
        wrapper.status = MMSocketRequestStatusGoing;
        [_socket writeData:request.payload withTimeout:request.timeoutInterval tag:1];
    }
}

- (void)cancelRequest:(id<MMSocketRequest>)request {
    MMSocketRequestWrapper *wrapper = _wrapperDictionary[request.taskIdentifier];
    if(wrapper) {
        wrapper.status = MMSocketRequestStatusCancelled;
    }
}

- (void)cancelRequest:(id<MMSocketRequest>)request withError:(NSError *)error {
    
}

- (void)cancelRequests:(NSArray<id<MMSocketRequest>> *)requests {
    for(id<MMSocketRequest> request in requests) {
        [self cancelRequest:request];
    }
}

- (void)cancelAllRequests {
    for(id<MMSocketRequest> request in _wrapperArray) {
        [self cancelRequest:request];
    }
}

- (void)cancelAllRequestsWithError:(NSError *)error {
    
}

- (void)startPing {
    if(_pingTimer) return;
    
    _pingTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_pingTimer, dispatch_walltime(NULL, 0), _pingInterval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_pingTimer, ^{
        _pingTimes ++;
        if(_pingTimes >= _maxPingTimes) {
            [self stopPing];
        } else {
            [self connect];
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
    MMSocketRequestWrapper *wrapper = _wrapperArray.firstObject;
    if(wrapper) {
        if(wrapper.status == MMSocketRequestStatusWaiting) {
            [self sendRequest:wrapper.request];
        }
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    BOOL disconnectedByUser = [sock.userData[MMSocketUserInfoDisconnectedByUserKey] boolValue];
    if(_pingTimer && _pingTimes < _maxPingTimes) {
        _connecting = !disconnectedByUser;
    } else {
        _connecting = NO;
    }
    
    _loginStatus = MMSocketConnectionLoginStatusTraveller;
    _connected = NO;
    if(disconnectedByUser) {
        //TODO: 報錯用戶取消
        [self cancelAllRequests];
    } else {
        for(MMSocketRequestWrapper *wrapper in _wrapperArray) {
            wrapper.status = MMSocketRequestStatusWaiting;
        }
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

@end
