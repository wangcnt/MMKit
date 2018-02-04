//
//  MMService.h
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/28.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMSessionConfiguration;
@class MMOperationQueue;

@interface MMService : NSObject

// serial queue
@property (nonatomic, strong, readonly) MMOperationQueue *serialQueue;

// concurrent queue
@property (nonatomic, strong, readonly) MMOperationQueue *highQueue;
@property (nonatomic, strong, readonly) MMOperationQueue *defaultQueue;
@property (nonatomic, strong, readonly) MMOperationQueue *backgroundQueue;

- (void)startService;
- (void)restartService;
- (void)stopService;

- (void)ping;

- (void)startServiceWithSessionConfigurations:(NSArray<id<MMSessionConfiguration>> *)configurations;

// example:
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion;

@end
