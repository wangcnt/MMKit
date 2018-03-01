//
//  MMServiceCenter.h
//  MMArchitecture
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMFoundation/MMProxy.h>
#import "MMService.h"

@class MMOperationQueue;

@interface MMServiceCenter : MMProxy <MMService>

// serial queue
@property (nonatomic, strong, readonly) MMOperationQueue *serialQueue;

// concurrent queue
@property (nonatomic, strong, readonly) MMOperationQueue *highQueue;
@property (nonatomic, strong, readonly) MMOperationQueue *defaultQueue;
@property (nonatomic, strong, readonly) MMOperationQueue *backgroundQueue;

- (void)registerService:(id<MMService>)service;
- (void)unregisterService:(id<MMService>)service;

@end
