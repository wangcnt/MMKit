//
//  MMServiceCenter.m
//  MMArchitecture
//
//  Created by WangQiang on 2018/2/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "MMServiceCenter.h"

#import "MMOperationQueue.h"

@implementation MMServiceCenter

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
    }
    return self;
}

@end
