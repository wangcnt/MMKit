//
//  MMServiceCenter.m
//  MMArchitecture
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMServiceCenter.h"

#import "MMOperationQueue.h"
#import "MMService.h"

@interface MMServiceCenter()
@property (nonatomic, strong) NSMutableDictionary *serviceDictionary;
@end

@implementation MMServiceCenter

- (instancetype)init {
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
    
    _serviceDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    return self;
}

- (void)registerService:(id<MMService>)service withIdentifier:(NSString *)identifier {
    service.center = self;
    if(!identifier || !service) {
        return;
    }
    _serviceDictionary[identifier] = service;
}

@end
