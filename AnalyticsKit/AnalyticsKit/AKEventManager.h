//
//  AKEventManager.h
//  AnalyticsKit
//
//  Created by WangQiang on 2018/2/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AKDefines.h"

@protocol AKEvent;

@interface AKEventManager : NSObject

@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, assign) NSTimeInterval uploadInterval;

@property (nonatomic, strong) id<AKService> service;    ///< 發送請求的service

+ (instancetype)sharedInstance;

- (void)setCurrentUserWithId:(NSString *)userId username:(NSString *)username;

// task: key -> task id, value -> task name
- (void)registerTaskWithId:(NSString *)identifier name:(NSString *)name;
- (void)registerTasksWithDictionary:(NSDictionary *)taskDictionary;
- (void)registerTasksWithFileAtPath:(NSString *)path;

// page: key -> page id, value -> page name
- (void)registerPageWithId:(NSString *)identifier name:(NSString *)name;
- (void)registerPagesWithDictionary:(NSDictionary *)pageDictionary;
- (void)registerPagesWithFileAtPath:(NSString *)path;

- (void)uploadEvent:(id<AKEvent>)event;

- (void)uploadIfNeeds;  ///< Nothing will be done if there is a timer uploading.
- (void)stopUpoloading;

- (void)startTimingForTaskWithId:(NSString *)taskId;
- (NSTimeInterval)duaringForTaskWithId:(NSString *)taskId;

@end
