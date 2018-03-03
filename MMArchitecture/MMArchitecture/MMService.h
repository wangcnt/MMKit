//
//  MMService.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/28.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MMServiceScope) {
    MMServiceScopeSingle,    ///< 單一服務
    MMServiceScopeGlobal     ///< 全局服務，-stopService將失效
};

@protocol MMSessionConfiguration;
@class MMOperationQueue, MMServiceCenter;

@protocol MMService <NSObject>

@required
@property (nonatomic, weak) MMServiceCenter *center;
@property (nonatomic, assign) MMServiceScope scope;
@property (nonatomic, assign) BOOL invalid; ///< If YES, all tasks won't be started or callbacked.

@required
- (void)callbackWithObjectedCompletion:(void (^)(id obj, NSError *error))completion object:(id)object error:(NSError *)error toMainThread:(BOOL)toMainThread;
- (void)callbackWithCompletion:(void (^)(NSError *error))completion error:(NSError *)error toMainThread:(BOOL)toMainThread;

@optional
- (void)startService;
- (void)restartService;
- (void)stopService;

@end

@interface MMService : NSObject <MMService>
@end
