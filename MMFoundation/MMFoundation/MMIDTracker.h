//
//  MMIDTracker.h
//  MMFoundation
//
//  Created by Mark on 15/6/23.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMTrackingInfo;

extern const NSTimeInterval MMIDTrackerTimeoutNone;

NS_ASSUME_NONNULL_BEGIN
@interface MMIDTracker : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDispatchQueue:(dispatch_queue_t)queue;

- (void)addID:(NSString *)identifier target:(nullable id)target selector:(nullable SEL)selector timeout:(NSTimeInterval)timeout;

- (void)addID:(NSString *)identifier
        block:(void (^_Nullable)(id _Nullable obj, id <MMTrackingInfo> info))block
      timeout:(NSTimeInterval)timeout;

- (void)addID:(NSString *)identifier trackingInfo:(id <MMTrackingInfo>)trackingInfo;

- (BOOL)invokeForID:(NSString *)identifier withObject:(nullable id)obj;

@property (nonatomic, readonly) NSUInteger numberOfIDs;

- (void)removeID:(NSString *)identifier;
- (void)removeAllIDs;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MMTrackingInfo <NSObject>

@property (nonatomic, readonly) NSTimeInterval timeout;

@property (nonatomic, readwrite, copy) NSString *identifier;

- (void)createTimerWithDispatchQueue:(dispatch_queue_t)queue;
- (void)cancelTimer;

- (void)invokeWithObject:(nullable id)obj;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MMBasicTrackingInfo : NSObject <MMTrackingInfo>

- (instancetype)initWithTarget:(nullable id)target selector:(nullable SEL)selector timeout:(NSTimeInterval)timeout;
- (instancetype)initWithBlock:(void (^_Nullable)(id _Nullable obj, id <MMTrackingInfo> info))block timeout:(NSTimeInterval)timeout;

@property (nonatomic, readonly) NSTimeInterval timeout;

@property (nonatomic, readwrite, copy) NSString *identifier;

- (void)createTimerWithDispatchQueue:(dispatch_queue_t)queue;
- (void)cancelTimer;

- (void)invokeWithObject:(nullable id)obj;

@end
NS_ASSUME_NONNULL_END
