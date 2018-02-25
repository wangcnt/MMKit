//
//  MMProgressManager.m
//  MMime
//
//  Created by Mark on 15/6/23.
//  Copyright (c) 2015年 Mark. All rights reserved.
//


/**
 *  NSProgress 的管理 类
 */
#import "MMProgressManager.h"

static NSString *const kMMProgressManagerBindingIdentifier  = @"kMMProgressManagerBindingIdentifier";
static NSString *const kMMProgressManagerBindingHandler     = @"kMMProgressManagerBindingHandler";

static NSString *const kMMProgressManagerObserverContext    = @"kMMProgressManagerObserverContext";

@interface MMProgressManager() {
    NSMutableArray *_progressArray;
}

@end

@implementation MMProgressManager

+ (instancetype)defaultManager {
    static MMProgressManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MMProgressManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if(self = [super init]) {
        _progressArray = [NSMutableArray array];
    }
    return self;
}

- (void)observeProgress:(NSProgress *)progress withIdentifier:(id)identifier handler:(MMProgressValueDidChangeHandler)handler {
    if(!progress || !identifier)        return;
    [progress setUserInfoObject:identifier forKey:kMMProgressManagerBindingIdentifier];
    if(handler) {
        [progress setUserInfoObject:handler forKey:kMMProgressManagerBindingHandler];
    }
    [_progressArray addObject:progress];
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew
                  context:(__bridge void *)(kMMProgressManagerObserverContext)];
}

- (void)removeObserverWithIdentifier:(id)identifier {
    if(!identifier)       return;
    NSProgress *target = nil;
    for(NSProgress *progress in _progressArray) {
        target = progress.userInfo[kMMProgressManagerBindingIdentifier];
        if([identifier isEqual:target]) {
            break;
        } else {
            target = nil;
        }
    }
    if(target) {
        [self releaseProgress:target];
    }
}

- (void)removeAllProgressObservers {
    for(NSProgress *progress in _progressArray) {
        [self releaseProgress:progress];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSString *cxt = (__bridge NSString *)(context);
    if([kMMProgressManagerObserverContext isEqualToString:cxt]
       && [keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        MMProgressValueDidChangeHandler handler = progress.userInfo[kMMProgressManagerBindingHandler];
        id identifier = progress.userInfo[kMMProgressManagerBindingIdentifier];
        if(identifier && handler) {
            handler(progress);
            [self releaseProgress:progress];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)releaseProgress:(NSProgress *)progress {
    if(!progress) {
        return;
    }
    [progress removeObserver:self forKeyPath:@"fractionCompleted"];
    [_progressArray removeObject:progress];
}

@end
