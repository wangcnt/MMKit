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
#import "MMServiceID.h"
#import <MMLog/MMLog.h>
#import <MMFoundation/MMDefines.h>

@interface MMService () {
}
@property (nonatomic, strong) MMHTTPSessionConfiguration *egHTTPConfiguration;

@end

@implementation MMService

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_queue_t task_queue = dispatch_queue_create("gaga", DISPATCH_QUEUE_SERIAL);
        MMHTTPSessionManager *httpSessionManager = [[MMHTTPSessionManager alloc] init];
        _egHTTPConfiguration = [[MMHTTPSessionConfiguration alloc] init];
//        _egHTTPConfiguration.userAgent = @"haha";
        [_egHTTPConfiguration setHeaderEntriesWithEntries:@{@"token" : @"token.token", @"User-Agent" : @"haha"}];
        _egHTTPConfiguration.task_queue = task_queue;
        _egHTTPConfiguration.sessionManager = httpSessionManager;
        
        _serviceID = [[MMServiceID alloc] init];
    }
    return self;
}

- (void)callbackWithObjectedCompletion:(void (^)(id obj, NSError *error))completion object:(id)object error:(NSError *)error toMainThread:(BOOL)toMainThread {
    __mm_exe_block__(completion, toMainThread, object, error);
}

- (void)callbackWithCompletion:(void (^)(NSError *error))completion error:(NSError *)error toMainThread:(BOOL)toMainThread {
    __mm_exe_block__(completion, toMainThread, error);
}

- (void)startService {
    MMLogInfo(@"%@ will start service.", self.class);
}

- (void)restartService {
    
}

- (void)stopService {
    if(_scope == MMServiceScopeSingle) {
        _invalid = YES;
    }
}

- (void)ping {
    
}

- (void)startServiceWithSessionConfigurations:(NSArray<id<MMSessionConfiguration>> *)configurations {
    
}



@synthesize invalid = _invalid;
@synthesize center = _center;
@synthesize scope = _scope;
@synthesize serviceID = _serviceID;
@synthesize defaultDB = _defaultDB;

@end
