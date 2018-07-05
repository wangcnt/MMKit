//
//  MMMediator.h
//  MMMediator
//
//  Created by Mark on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMediator : NSObject

+ (instancetype)sharedInstance;

// 远程App调用入口
- (id)resourceForURL:(NSURL *)url withCompletion:(void(^)(NSDictionary *info))completion;

// 本地组件调用入口
- (id)performAction:(NSString *)actionName withTarget:(NSString *)targetName parameters:(NSDictionary *)parameters shouldCacheTarget:(BOOL)shouldCacheTarget;

- (void)releaseCachedTargetWithTarget:(NSString *)targetName;

@end
