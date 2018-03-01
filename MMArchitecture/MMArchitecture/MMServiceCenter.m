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
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<MMService>> *serviceDictionary;
@property (nonatomic, strong) NSMutableArray<id<MMService>> *serviceArray;
@end

@implementation MMServiceCenter

- (void)initialize {
    [super initialize];
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
    
    _serviceDictionary = [[NSMutableDictionary<NSString *, id<MMService>> alloc] initWithCapacity:1];
    _serviceArray = [NSMutableArray<id<MMService>> arrayWithCapacity:1];
}

- (void)registerService:(id<MMService>)service {
    service.center = self;
    [super addDelegate:service];
}

- (void)unregisterService:(id<MMService>)service {
    [super removeDelegate:service];
}

@synthesize center;

@synthesize identifier;

@end
