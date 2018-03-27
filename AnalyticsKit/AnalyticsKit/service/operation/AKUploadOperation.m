//
//  AKUploadOperation.m
//  AnalyticsKit
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AKUploadOperation.h"

#import "AKUploadRequest.h"

@interface AKUploadOperation ()
@property (nonatomic, strong) AKUploadRequest *uploadRequest;
@end

@implementation AKUploadOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        _uploadRequest = [[AKUploadRequest alloc] init];
        _request = _uploadRequest;
    }
    return self;
}

- (void)willStart {
    _uploadRequest.events = _events;
    [super willStart];
}

- (BOOL)shouldRetry {
    return NO;
}

- (void)loadFinished {
    
    [super loadFinished];
}

@end
