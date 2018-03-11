//
//  MMApplication.m
//  MMCoreServices
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMApplication.h"

NSString *const MMCoreServicesErrorDomain = @"MMCoreServicesErrorDomain";

@implementation MMApplication

+ (instancetype)sharedInstance {
    static MMApplication *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MMApplication alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
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
