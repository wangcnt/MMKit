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

- (void)start {
    @autoreleasepool {
        Protocol *requestProtocol = @protocol(MMRequest);
        Protocol *configurationProtocol = @protocol(MMSessionConfiguration);
        NSAssert([self.request conformsToProtocol:requestProtocol], @"%@.request MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(requestProtocol));
        NSAssert([self.configuration conformsToProtocol:configurationProtocol], @"%@.configuration MUST conform to protocol: %@.", NSStringFromClass(self.class), NSStringFromProtocol(configurationProtocol));
        
#if DEBUG
        sleep(arc4random() % 5 + 2);
#endif
        if(_step) {
            _step(MMRequestStepPreparing);
        }
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
            NSException *exception = nil;
            @try {
                [self sendRequest];
            }
            @catch (NSException *e) {
                exception = e;
            }
            @finally {
                if(exception) {
                    self.error = [NSError errorWithDomain:MMCoreServicesErrorDomain code:MMCoreServicesErrorCodeException userInfo:@{NSLocalizedDescriptionKey : [NSArray arrayWithArray:exception.backtrace]}];
                    [self loadFinished];
                }
            }
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
    // 每次发请求之前清空error和response
    _error = nil;
    _response = nil;
    
    // 先各自准备
    [self.request prepare];
    
    // 再由NSOperation补充
    [self presendRequest];
    
    // 发送出去
    __weak typeof(self) weakedSelf = self;
    dispatch_block_t block = ^ {
        [weakedSelf.sessionManager startRequest:weakedSelf.request withCompletion:^(id<MMResponse> res) {
            _response = res;
            if([weakedSelf shouldRetry]) {
                [weakedSelf sendRequest];
            } else {
                [weakedSelf loadFinished];
            }
        }];
    };
    
    if(self.configuration.task_queue) {
        dispatch_async(self.configuration.task_queue, block);
    } else {
        block();
    }
}

- (void)presendRequest {
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
        self.state = MMAsyncOperationStateFinished;
        if(!self.error) {
            self.error = _response.error;
            //TODO: write the error into the long file in the sandbox
        }
        if(_step) {
            _step(MMRequestStepFinished);
        }
        _endTimestamp = CFAbsoluteTimeGetCurrent();
    }
}

- (void)setConfiguration:(id<MMSessionConfiguration>)configuration {
    if(_configuration != configuration) {
        _configuration = configuration;
        if(self.request) {
            self.request.configuration = _configuration;
        }
    }
}

- (void)setRequest:(id<MMRequest>)request {
    if(_request != request) {
        _request = request;
        if(self.configuration) {
            _request.configuration = self.configuration;
        }
    }
}

- (void)setStep:(MMRequestStepHandler)step {
    if(_step != step) {
        _step = step;
        self.request.step = _step;
    }
}

- (double)consumedTimestamp {
    return _endTimestamp - _startTimestamp;
}

@synthesize error = _error;
@synthesize configuration = _configuration;
@synthesize retryedTimes = _retryedTimes;
@synthesize maxRetryTimes = _maxRetryTimes;
@synthesize response = _response;
@synthesize request = _request;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize sessionManager = _sessionManager;
@synthesize consumedTimestamp = _consumedTimestamp;
@synthesize step = _step;

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
