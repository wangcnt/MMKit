//
//  MMServiceCenter.m
//  MMCoreServices
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

- (instancetype)init {
    self = [super init];
    _serialQueue = [[MMOperationQueue alloc] init];
    _serialQueue.maxConcurrentOperationCount = 1;
    _serialQueue.qualityOfService = NSQualityOfServiceUserInteractive;
    
    _serviceDictionary = [[NSMutableDictionary<NSString *, id<MMService>> alloc] initWithCapacity:1];
    _serviceArray = [NSMutableArray<id<MMService>> arrayWithCapacity:1];
    return self;
}

- (void)registerService:(id<MMService>)service {
    service.center = self;
    [super addDelegate:service];
}

- (void)unregisterService:(id<MMService>)service {
    if(service.scope == MMServiceScopeGlobal) {
        return;
    }
    [super removeDelegate:service];
}

- (void)startService:(id<MMService>)service {
    if(!service) return;
    [self registerService:service];
    [service startService];
}

- (void)stopService:(id<MMService>)service withCompletion:(void (^)(NSError *error))completion {
    if(service.scope == MMServiceScopeSingle) {
        [service stopService];
    }
    if(completion) {
        completion(nil);
    }
}

@end
