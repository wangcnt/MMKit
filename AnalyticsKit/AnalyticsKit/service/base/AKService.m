//
//  AKService.m
//  AnalyticsKit
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AKService.h"

#import "AKUploadOperation.h"
#import "AKUploadResponse.h"
#import <MMCoreServices/MMService.h>
#import <MMFoundation/MMDefines.h>

@implementation AKService

- (instancetype)init {
    if (self = [super init]) {
        self.scope = MMServiceScopeGlobal;
    }
    return self;
}

- (void)startService {
    NSLog(@"%@ will start service.", self.class);
}

- (void)uploadEvent:(id<AKEvent>)event withCompletion:(void (^)(NSError *error))completion {
    if(!event) {
        __mm_exe_block__(completion, YES, nil);
        return;
    }
    [self uploadEvents:@[event] withCompletion:completion];
}

- (void)uploadEvents:(NSArray<id<AKEvent>> *)events withCompletion:(void (^)(NSError *error))completion {
    AKUploadOperation *operation = [[AKUploadOperation alloc] init];
    operation.events = events;
    operation.serviceID = self.serviceID;
    __weak typeof(AKUploadOperation) *wop = operation;
    operation.completionBlock = ^{
        __mm_exe_block__(completion, YES, wop.error);
        __mm_dispatch_async__(completion, dispatch_get_main_queue(), nil);
    };
    [[MMApplication sharedInstance].backgroundQueue addOperation:operation];
}

@end
