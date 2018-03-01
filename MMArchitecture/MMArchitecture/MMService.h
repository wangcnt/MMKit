//
//  MMService.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/28.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMSessionConfiguration;
@class MMOperationQueue, MMServiceCenter;

@protocol MMService <NSObject>

@required
@property (nonatomic, weak) MMServiceCenter *center;
@property (nonatomic, strong) NSString *identifier;

@optional
- (void)startService;
- (void)restartService;
- (void)stopService;

@end

@interface MMService : NSObject <MMService>

@property (nonatomic, weak) MMServiceCenter *center;
@property (nonatomic, strong) NSString *identifier;

- (void)startService;
- (void)restartService;
- (void)stopService;

- (void)ping;

- (void)startServiceWithSessionConfigurations:(NSArray<id<MMSessionConfiguration>> *)configurations;

// example:
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion;

@end
