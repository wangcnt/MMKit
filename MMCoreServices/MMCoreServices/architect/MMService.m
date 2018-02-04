//
//  MMService.m
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/28.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "MMService.h"

#import "MMOperationQueue.h"
#import "MMOperation.h"
#import "MMResponse.h"
#import "MMSessionConfiguration.h"
#import "MMSessionManager.h"

@interface MMService () {
}
@property (nonatomic, strong) MMHTTPSessionConfiguration *egHTTPConfiguration;

@end

@implementation MMService

- (instancetype)init {
    self = [super init];
    if (self) {
        _serialQueue = [[MMOperationQueue alloc] init];
        _serialQueue.maxConcurrentOperationCount = 1;
        _serialQueue.qualityOfService = NSQualityOfServiceUserInteractive;
        
        _highQueue = [[MMOperationQueue alloc] init];
        _highQueue.maxConcurrentOperationCount = 3;
        _highQueue.qualityOfService = NSQualityOfServiceUserInteractive;
        
        _defaultQueue = [[MMOperationQueue alloc] init];
        _defaultQueue.maxConcurrentOperationCount = 3;
        _defaultQueue.qualityOfService = NSQualityOfServiceDefault;
        
        _backgroundQueue = [[MMOperationQueue alloc] init];
        _backgroundQueue.maxConcurrentOperationCount = 3;
        _backgroundQueue.qualityOfService = NSQualityOfServiceBackground;
        
        dispatch_queue_t task_queue = dispatch_queue_create("gaga", DISPATCH_QUEUE_SERIAL);
        MMHTTPSessionManager *egHTTPSessionManager = [[MMHTTPSessionManager alloc] init];
        _egHTTPConfiguration = [[MMHTTPSessionConfiguration alloc] init];
//        _egHTTPConfiguration.userAgent = @"haha";
        _egHTTPConfiguration.token = @"token.token";
        _egHTTPConfiguration.task_queue = task_queue;
        _egHTTPConfiguration.sessionManager = egHTTPSessionManager;
        
        int j = 000  ;
        j = 000  ;
    }
    return self;
}

- (void)startService {
    
}

- (void)restartService {
    
}

- (void)stopService {
    
}

- (void)ping {
    
}

- (void)startServiceWithSessionConfigurations:(NSArray<id<MMSessionConfiguration>> *)configurations {
    
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion {
    [self loginWithUsername:username password:password taskIdentifier:nil completion:completion];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password taskIdentifier:(NSString *)taskIdentifier completion:(void (^)(NSError *error))completion {
    MMHTTPOperation *operation = [[MMHTTPOperation alloc] init];
    operation.configuration = _egHTTPConfiguration;
    __weak typeof(MMHTTPOperation) *weakedOp = operation;
    operation.completionBlock = ^{
        __unused id<MMHTTPResponse> response = (id<MMHTTPResponse>)weakedOp.response;
        if(completion) {
            completion(weakedOp.error);
        }
    };
    [_highQueue addOperation:operation];
}

@end
