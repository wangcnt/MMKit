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

@interface MMOperation ()
@property (nonatomic, assign) BOOL scheduled;
@property (nonatomic, assign) BOOL scheduling;

@property (nonatomic, assign, readonly) double startTimestamp;
@property (nonatomic, assign, readonly) double endTimestamp;

@end

@implementation MMOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeoutInterval = 60;
    }
    return self;
}

- (void)start {
    NSAssert(self.request, @"request must not be nil.");
    
    _startTimestamp = CFAbsoluteTimeGetCurrent();
    
    if (self.cancelled){
        [self willChangeValueForKey:@"isFinished"];
        _scheduled = YES;
        [self didChangeValueForKey:@"isFinished"];
    } else {
        [self willChangeValueForKey:@"isExecuting"];
        _scheduling = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        NSException *exception = nil;
        @try {
            @autoreleasepool {
                [self sendRequest];
            }
        }
        @catch (NSException *e) {
            exception = e;
        }
        @finally {
            if(exception) {
                self.error = [NSError errorWithDomain:@"com.markwong.mmcoreservices.operation.error.domain" code:1 userInfo:@{NSLocalizedDescriptionKey : [NSArray arrayWithArray:exception.callStackSymbols]}];
                [self loadFinished];
            }
        }
    }
}

- (void)cancel {
    [super cancel];
    
}

- (id<MMSessionManager>)sessionManager {
    return self.configuration.sessionManager;
}

- (void)sendRequest {
    NSAssert(self.sessionManager, @"Session Manager must not be nil.");
    
    _response = nil;
    
    [self.request prepare];
    [self presendRequest];
    
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
    if(self.request && self.configuration)  {
        self.request.configuration = self.configuration;
    }
}

- (BOOL)shouldRetry {
    return NO;
}

- (BOOL)shouldContinue {
    return NO;
}

- (void)loadFinished {
    // override by subclasses
    
    if(!self.error) {
        //TODO: write the error into the long file in the sandbox 
    }
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _scheduled = YES;
    _scheduling = NO;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
    
    _endTimestamp = CFAbsoluteTimeGetCurrent();
}

/** 跟同步不同的地方。
 * 必须重载Operation的实例方法 isConcurrent并在该方法中返回 YES
 */
- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isFinished{
    return _scheduled;
}

- (BOOL)isExecuting{
    return _scheduling;
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

- (double)consumedTimestamp {
    return self.endTimestamp - self.startTimestamp;
}

@synthesize error = _error;
@synthesize configuration = _configuration;
@synthesize retryedTimes = _retryedTimes;
@synthesize maxRetryTimes = _maxRetryTimes;
@synthesize response = _response;
@synthesize request = _request;
@synthesize timeoutInterval = _timeoutInterval;

@end

@implementation MMHTTPOperation

- (void)start {
    NSAssert([super.request conformsToProtocol:@protocol(MMHTTPRequest)], @"request MUST conform to protocol: MMHTTPRequest.");
    [super start];
}

- (void)sendRequest {
    NSAssert([self.sessionManager conformsToProtocol:@protocol(MMHTTPSessionManager)], @"Session Manager MUST conform to protocol: MMHTTPSessionManager.");
    [super sendRequest];
}

- (void)setConfiguration:(id<MMSessionConfiguration>)configuration {
    NSAssert([configuration conformsToProtocol:@protocol(MMHTTPSessionConfiguration)], @"Configuration MUST conforms to protocol: MMHTTPSessionConfiguration.");
    super.configuration = configuration;
}

@end


@implementation MMSocketOperation

- (void)start {
    NSAssert([super.request conformsToProtocol:@protocol(MMSocketRequest)], @"request MUST conform to protocol: MMSocketRequest.");
    [super start];
}

- (void)sendRequest {
    NSAssert([self.sessionManager conformsToProtocol:@protocol(MMSocketSessionManager)], @"Session Manager MUST conform to protocol: MMSocketSessionManager.");
    [super sendRequest];
}

- (void)setConfiguration:(id<MMSessionConfiguration>)configuration {
    NSAssert([configuration conformsToProtocol:@protocol(MMSocketSessionConfiguration)], @"Configuration MUST conforms to protocol: MMSocketSessionConfiguration.");
    super.configuration = configuration;
}

@end
