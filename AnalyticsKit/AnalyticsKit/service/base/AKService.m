//
//  AKService.m
//  AnalyticsKit
//
//  Created by WangQiang on 2018/2/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "AKService.h"

#import "AKUploadOperation.h"
#import "AKUploadResponse.h"

@implementation AKService

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)callbackWithCompletion:(void (^)(NSError *error))completion error:(NSError *)error {
    if(completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error);
        });
    }
}

- (void)uploadEvent:(id<AKEvent>)event withCompletion:(void (^)(NSError *error))completion {
    if(!event) {
        [self callbackWithCompletion:completion error:nil];
        return;
    }
    [self uploadEvents:@[event] withCompletion:completion];
}

- (void)uploadEvents:(NSArray<id<AKEvent>> *)events withCompletion:(void (^)(NSError *error))completion {
    AKUploadOperation *operation = [[AKUploadOperation alloc] init];
    operation.events = events;
    __weak typeof(AKUploadOperation) *wop = operation;
    operation.completionBlock = ^{
        [self callbackWithCompletion:completion error:wop.response.error];
    };
    [self.center.backgroundQueue addOperation:operation];
}

@end
