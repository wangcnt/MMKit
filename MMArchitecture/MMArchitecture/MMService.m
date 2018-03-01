//
//  MMService.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/28.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMService.h"

#import "MMOperationQueue.h"
#import "MMOperation.h"
#import "MMResponse.h"
#import "MMSessionConfiguration.h"
#import "MMSessionManager.h"
#import "MMServiceCenter.h"

@interface MMService () {
}
@property (nonatomic, strong) MMHTTPSessionConfiguration *egHTTPConfiguration;

@end

@implementation MMService

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_queue_t task_queue = dispatch_queue_create("gaga", DISPATCH_QUEUE_SERIAL);
        MMHTTPSessionManager *egHTTPSessionManager = [[MMHTTPSessionManager alloc] init];
        _egHTTPConfiguration = [[MMHTTPSessionConfiguration alloc] init];
//        _egHTTPConfiguration.userAgent = @"haha";
        _egHTTPConfiguration.token = @"token.token";
        _egHTTPConfiguration.task_queue = task_queue;
        _egHTTPConfiguration.sessionManager = egHTTPSessionManager;
    }
    return self;
}

- (void)startService {
    NSLog(@"%@ will start service.", self.class);
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
    [self loginWithUsername:username password:password connectionID:nil completion:completion];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password connectionID:(NSString *)connectionID completion:(void (^)(NSError *error))completion {
    MMHTTPOperation *operation = [[MMHTTPOperation alloc] init];
    operation.configuration = _egHTTPConfiguration;
    __weak typeof(MMHTTPOperation) *weakedOp = operation;
    operation.completionBlock = ^{
        __unused id<MMHTTPResponse> response = (id<MMHTTPResponse>)weakedOp.response;
        if(completion) {
            completion(weakedOp.error);
        }
    };
    [self.center.highQueue addOperation:operation];
}

@end
