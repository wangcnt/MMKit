//
//  MMService.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/28.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MMDatabaseKit/MMCoreData.h>

typedef NS_ENUM(NSInteger, MMServiceScope) {
    MMServiceScopeSingle,    ///< 單一服務
    MMServiceScopeGlobal     ///< 全局服務，-stopService將失效
};

@protocol MMSessionConfiguration, MMServiceID;
@class MMOperationQueue, MMServiceCenter;

@protocol MMService <NSObject>

@required
@property (nonatomic, weak) MMServiceCenter *center;
@property (nonatomic, assign) MMServiceScope scope;
@property (nonatomic, assign) BOOL invalid; ///< If YES, all tasks won't be started but callback with a MMCoreServiceErrorCodeInvalidService.

@property (nonatomic, strong) id<MMServiceID> serviceID;

@property (nonatomic, strong, readonly) id<MMCoreDataStore> defaultDB; ///< Default is MMCoreDatatStore type. You can extend MMService protocol by adding an id<MMDatabase> property to use your own db type.

@optional

- (BOOL)openDB;
- (BOOL)closeDB;

- (void)startService;
- (void)restartService;
- (void)stopService;

// Instead, you can use the shortcut block executioner __mm_exe_block__(block, BOOL_onMainThread, ...)
- (void)callbackWithObjectedCompletion:(void (^)(id obj, NSError *error))completion object:(id)object error:(NSError *)error toMainThread:(BOOL)toMainThread;
- (void)callbackWithCompletion:(void (^)(NSError *error))completion error:(NSError *)error toMainThread:(BOOL)toMainThread;
@end

@interface MMService : NSObject <MMService>
@end
