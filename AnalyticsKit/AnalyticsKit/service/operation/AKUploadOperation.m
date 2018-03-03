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

- (void)setEvents:(NSArray<id<AKEvent>> *)events {
    if(_events != events) {
        _events = events;
        _uploadRequest.events = _events;
    }
}

- (void)presendRequest {
    [super presendRequest];
    _uploadRequest.events = _events;
}

- (BOOL)shouldRetry {
    return NO;
}

- (void)loadFinished {
    
    [super loadFinished];
}

@end
