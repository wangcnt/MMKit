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
#import "MMServiceID.h"

@interface MMServiceCenter()
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<MMService>> *serviceDictionary;
@end

@implementation MMServiceCenter

- (instancetype)init {
    self = [super init];
    _serialQueue = [[MMOperationQueue alloc] init];
    _serialQueue.maxConcurrentOperationCount = 1;
    _serialQueue.qualityOfService = NSQualityOfServiceUserInteractive;
    
    _serviceDictionary = [[NSMutableDictionary<NSString *, id<MMService>> alloc] initWithCapacity:2];
    return self;
}

- (void)registerService:(id<MMService>)service {
    service.center = self;
    NSString *serviceKey = service.serviceID.serviceKey;
    if(serviceKey.length && service) {
        _serviceDictionary[serviceKey] = service;
        [super addDelegate:service];
    }
}

- (void)unregisterService:(id<MMService>)service {
    NSString *serviceKey = service.serviceID.serviceKey;
    if(!serviceKey) {
        return;
    }
    if(service.scope == MMServiceScopeGlobal) {
        return;
    }
    [_serviceDictionary removeObjectForKey:serviceKey];
    [super removeDelegate:service];
}

- (id<MMService>)serviceForServiceID:(id<MMServiceID>)serviceID {
    NSString *serviceKey = serviceID.serviceKey;
    if(!serviceKey.length) {
        return nil;
    }
    return _serviceDictionary[serviceKey];
}

- (void)startService:(id<MMService>)service {
    if(!service || !service.serviceID.serviceKey) return;
    [self registerService:service];
    [service startService];
}

- (void)stopService:(id<MMService>)service withCompletion:(void (^)(NSError *error))completion {
    if(!service || !service.serviceID.serviceKey) {
        if(completion) {
            completion(nil);
        }
        return;
    }
    if(service.scope == MMServiceScopeSingle) {
        [service stopService];
    }
    if(completion) {
        completion(nil);
    }
}

@end
