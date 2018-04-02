//
//  MMOperation.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/22.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMOperation.h"

#import "MMRequest.h"
#import "MMSessionManager.h"
#import "MMSessionConfiguration.h"
#import "MMResponse.h"
#import <MMFoundation/MMDefines.h>
#import "MMApplication.h"
#import <MMFoundation/NSExceptionAdditions.h>
#import <MMLog/MMLog.h>

typedef NS_ENUM(NSInteger, MMAsyncOperationState) {
    MMAsyncOperationStatePreparing,
    MMAsyncOperationStateExecuting,
    MMAsyncOperationStateFinished
};

static inline NSString *MMAsyncOperationKeyPathForState(MMAsyncOperationState state) {
    switch (state) {
        case MMAsyncOperationStatePreparing:    return @"isReady";
        case MMAsyncOperationStateExecuting:    return @"isExecuting";
        case MMAsyncOperationStateFinished:     return @"isFinished";
    }
}

@interface MMOperation () {
    double _startTimestamp;
    double _endTimestamp;
    dispatch_queue_t _dispatch_queue;
}
@property(nonatomic, assign) MMAsyncOperationState state;

@end

@implementation MMOperation

- (instancetype)init {
    if (self = [super init]) {
        _timeoutInterval = 60;
        NSString *identifier = [NSString stringWithFormat:@"%@.%@(%p)", mm_application_name(), NSStringFromClass(self.class), self];
        _dispatch_queue = dispatch_queue_create(identifier.UTF8String, DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(_dispatch_queue, (__bridge const void *)(_dispatch_queue), (__bridge void *)(self), NULL);
    }
    return self;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    __block BOOL isExecuting;
    [self performBlockAndWait:^{
        isExecuting = self.state == MMAsyncOperationStateExecuting;
    }];
    return isExecuting;
}

- (BOOL)isFinished {
    __block BOOL isFinished;
    [self performBlockAndWait:^{
        isFinished = self.state == MMAsyncOperationStateFinished;
    }];
    return isFinished;
}

- (void)performBlockAndWait:(dispatch_block_t)block {
    void *context = dispatch_get_specific((__bridge const void *)(_dispatch_queue));
    if (context == (__bridge void *)(self)) {
        block();
    } else {
        dispatch_sync(_dispatch_queue, block);
    }
}

- (void)willStart {
    self.request.configuration = self.configuration;
    self.request.progressHandler = self.progressHandler;
    self.request.stepHandler = self.stepHandler;
    self.request.serviceID = self.serviceID;
}

- (void)start {
    @autoreleasepool {
        Protocol *protocol = @protocol(MMRequest);
        NSAssert([self.request conformsToProtocol:protocol], @"%@.request MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(protocol));
        
        protocol = @protocol(MMSessionConfiguration);
        NSAssert([self.configuration conformsToProtocol:protocol], @"%@.configuration MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(protocol));
        
        protocol = @protocol(MMServiceID);
        NSAssert([self.serviceID conformsToProtocol:protocol], @"%@.serviceID MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(protocol));
        
        [self willStart];
        
#if DEBUG
        sleep(arc4random() % 5 + 2);
#endif
        __mm_exe_block__(_stepHandler, NO, MMRequestStepPreparing);
#if DEBUG
        sleep(arc4random() % 5 + 2);
#endif
        
        _startTimestamp = CFAbsoluteTimeGetCurrent();
        
        if (self.isCancelled) {
            self.error = [NSError errorWithDomain:MMCoreServicesErrorDomain code:MMCoreServicesErrorCodeOperationCancelled userInfo:@{NSLocalizedDescriptionKey : @"Request cancelled."}];
            [self loadFinished];
            return;
        }
        __block BOOL shouldContinue = YES;
        [self performBlockAndWait:^{
            // Ignore this call if the operation is already executing or if has finished already
            if (self.state != MMAsyncOperationStatePreparing) {
                shouldContinue = NO;
            } else {
                // Signal the beginning of operation
                self.state = MMAsyncOperationStateExecuting;
            }
        }];
        if(shouldContinue) {
            [self sendRequest];
        }
    }
}

- (void)setState:(MMAsyncOperationState)state {
    [self performBlockAndWait:^{
        NSString *oldStateKey = MMAsyncOperationKeyPathForState(_state);
        NSString *newStateKey = MMAsyncOperationKeyPathForState(state);
        
        [self willChangeValueForKey:oldStateKey];
        [self willChangeValueForKey:newStateKey];
        
        _state = state;
        
        [self didChangeValueForKey:newStateKey];
        [self didChangeValueForKey:oldStateKey];
    }];
}

- (id<MMSessionManager>)sessionManager {
    return self.configuration.sessionManager;
}

- (void)sendRequest {
    // 先各自准备
    [self.request prepare];
    
    // 再由NSOperation补充
    [self willSend];
    
    // 发送出去
    __weak typeof(self) weakedSelf = self;
    dispatch_block_t block = ^ {
        [weakedSelf.sessionManager startRequest:weakedSelf.request withCompletion:^(id<MMResponse> res) {
            _response = res;
            if(weakedSelf.cancelled) {
                [weakedSelf loadFinished];
            } else {
                if([weakedSelf shouldRetry] && _retriedTimes++<_maxRetryTimes) {
                    _error = nil;
                    _response = nil;
                    [weakedSelf sendRequest];
                } else if([weakedSelf shouldContinue]) {
                    [weakedSelf sendRequest];
                } else {
                    [weakedSelf loadFinished];
                }
            }
        }];
    };
    
    if(self.configuration.task_queue) {
        dispatch_async(self.configuration.task_queue, block);
    } else {
        block();
    }
}

- (void)cancel {
    _error = [NSError errorWithDomain:MMCoreServicesErrorDomain code:MMCoreServicesErrorCodeRequestCancelled userInfo:@{NSLocalizedDescriptionKey : @"Operation cancelled."}];
    [super cancel];
}

- (void)willSend {
}

- (BOOL)shouldRetry {
    return NO;
}

- (BOOL)shouldContinue {
    return NO;
}

- (void)loadFinished {
    // override by subclasses
    if (self.state != MMAsyncOperationStateFinished) {
        [self persist];
        
        if(!self.error) {
            self.error = _response.error;
            //TODO: write the error into the long file in the sandbox
            MMLogError(@"%@ error:%@", self.request.command, self.error);
        }
        __mm_exe_block__(_stepHandler, NO, MMRequestStepFinished);
        _endTimestamp = CFAbsoluteTimeGetCurrent();
        
        // The current NSOperation will be terminated.
        self.state = MMAsyncOperationStateFinished;
    }
}

- (void)persist {
}

- (double)consumedTimestamp {
    return _endTimestamp - _startTimestamp;
}

@synthesize error = _error;
@synthesize configuration = _configuration;
@synthesize retriedTimes = _retriedTimes;
@synthesize maxRetryTimes = _maxRetryTimes;
@synthesize response = _response;
@synthesize request = _request;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize sessionManager = _sessionManager;
@synthesize consumedTimestamp = _consumedTimestamp;
@synthesize stepHandler = _stepHandler;
@synthesize progressHandler = _progressHandler;

@synthesize serviceID = _serviceID;

@end

@implementation MMHTTPOperation

- (void)start {
    Protocol *requestProtocol = @protocol(MMHTTPRequest);
    Protocol *configurationProtocol = @protocol(MMHTTPSessionConfiguration);
    NSAssert([super.request conformsToProtocol:requestProtocol], @"%@.request MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(requestProtocol));
    NSAssert([super.configuration conformsToProtocol:configurationProtocol], @"%@.configuration MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(configurationProtocol));
    
    [super start];
}

@end


@implementation MMSocketOperation

- (void)start {
    Protocol *requestProtocol = @protocol(MMSocketRequest);
    Protocol *configurationProtocol = @protocol(MMSocketSessionConfiguration);
    NSAssert([super.request conformsToProtocol:requestProtocol], @"%@.request MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(requestProtocol));
    NSAssert([super.configuration conformsToProtocol:configurationProtocol], @"%@.configuration MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(configurationProtocol));

    [super start];
}

@synthesize connectionID = _connectionID;

@end
