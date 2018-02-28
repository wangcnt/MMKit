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
    
    _serviceDictionary = [[NSMutableDictionary<NSString *, id<MMService>> alloc] initWithCapacity:1];
    _serviceArray = [NSMutableArray<id<MMService>> arrayWithCapacity:1];
    return self;
}

- (void)registerService:(id<MMService>)service withIdentifier:(NSString *)identifier {
    service.center = self;
    if(!identifier || !service) {
        return;
    }
    _serviceDictionary[identifier] = service;
    [_serviceArray addObject:service];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if(_serviceArray) {
        for(id<MMService> service in _serviceArray) {
            if([service respondsToSelector:invocation.selector]) {
                NSLog(@"MMServiceCenter will invoke %@'s method: %@", service.class,  NSStringFromSelector(invocation.selector));
                invocation.target = service;
                [invocation invoke];
            } else {
                NSLog(@"%@ doesn't responds to selector: %@", service.class, NSStringFromSelector(invocation.selector));
            }
        }
    } else {
        NSLog(@"There must be at least one MMService-implemented service was registerred in MMServiceCenter.");
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    for(id<MMService> service in _serviceArray) {
        if([service isKindOfClass:NSObject.class]) {
            NSMethodSignature *signature = [(NSObject *)service methodSignatureForSelector:sel];
            return signature;
        }
    }
    NSMethodSignature *signature = [super methodSignatureForSelector:sel];
    return signature;
}

@end
