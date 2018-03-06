//
//  AKEventManager.m
//  AnalyticsKit
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AKEventManager.h"

#import "AKEvent.h"
#import "AKService.h"
#import <MMFoundation/MMDiskCache.h>

@interface AKEventManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *taskDictionary;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *pageDictionary;
@property (nonatomic, strong) NSMutableArray<id<AKEvent>> *events;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *timeDictionary;
@property (nonatomic, strong) dispatch_source_t timer;  ///< 上傳統計信息的定時器
@end

@implementation AKEventManager

+ (instancetype)sharedInstance {
    static AKEventManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AKEventManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskDictionary = [NSMutableDictionary<NSString *, NSString *> dictionary];
        _pageDictionary = [NSMutableDictionary<NSString *, NSString *> dictionary];
        _events = [NSMutableArray<id<AKEvent>> array];
        _timeDictionary = [NSMutableDictionary<NSString *, NSNumber *> dictionary];
        [self loadEvents];
    }
    return self;
}

- (void)loadEvents {
    [MMDiskCache sharedInstance];
}

- (id<AKService>)service {
    if(!_service) {
        _service = [[AKService alloc] init];
        //TODO: sessionConfiguration
    }
    return _service;
}

- (void)setUploadInterval:(NSTimeInterval)uploadInterval {
    if(_uploadInterval != uploadInterval) {
        _uploadInterval = uploadInterval;
        if(_timer) {
            [self stopUploading];
            [self scheduleTimerIfNeeds];
        }
    }
}

- (void)setCurrentUserWithId:(NSString *)userId username:(NSString *)username {
    _userId = userId;
    _username = username;
}

// task: key -> task id, value -> task name
- (void)registerTaskWithId:(NSString *)identifier name:(NSString *)name {
    if(!identifier || !name) {
        return;
    }
    [self registerTasksWithDictionary:@{identifier : name}];
}

- (void)registerTasksWithFileAtPath:(NSString *)path {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    [self registerTasksWithDictionary:dic];
}

- (void)registerTasksWithDictionary:(NSDictionary *)taskDictionary {
    [self.taskDictionary addEntriesFromDictionary:taskDictionary];
}

// page: key -> page id, value -> page name
- (void)registerPageWithId:(NSString *)identifier name:(NSString *)name {
    if(!identifier || !name) {
        return;
    }
    [self registerPagesWithDictionary:@{identifier : name}];
}

- (void)registerPagesWithFileAtPath:(NSString *)path {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    [self registerPagesWithDictionary:dic];
}

- (void)registerPagesWithDictionary:(NSDictionary *)pageDictionary {
    [self.pageDictionary addEntriesFromDictionary:pageDictionary];
}

- (void)uploadEvent:(id<AKEvent>)event {
    if(!event) {
        return;
    }
    [_events addObject:event];
    [self uploadIfNeeds];
}

- (void)uploadIfNeeds {
    if(!_events.count)  {
        [self stopUploading];
        return;
    }
    [self scheduleTimerIfNeeds];
}

- (void)scheduleTimerIfNeeds {
    if(!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, _uploadInterval, 0);
        dispatch_source_set_event_handler(_timer, ^{
            [self upload];
        });
        dispatch_source_set_cancel_handler(_timer, ^{
        });
    }
}

- (void)upload {
    NSArray<id<AKEvent>> *events = _events;
    [self.service uploadEvents:events withCompletion:^(NSError *error) {
        if(error) {
        } else {
            [_events removeObjectsInArray:events];
            //TODO: wirte into file use MMDiskCache
            if(!_events.count) {
                [self stopUploading];
            }
        }
    }];
}

- (void)stopUploading {
    [self stopTimer];
}

- (void)stopTimer {
    if(_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)startTimingForTaskWithId:(NSString *)taskId {
    if(!taskId.length) {
        return;
    }
    double time = CFDateGetAbsoluteTime(nil);
    _timeDictionary[taskId] = @(time);
}

- (NSTimeInterval)duaringForTaskWithId:(NSString *)taskId {
    double duaring = 0;
    if(taskId.length) {
        duaring = CFDateGetAbsoluteTime(nil) - _timeDictionary[taskId].doubleValue;
    }
    return duaring;
}

@end
