//
//  MMTimer.m
//  MMFoundation
//
//  Created by Mark on 15/6/23.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMTimer.h"

@implementation MMTimer
{
	BOOL isStarted;
	
	dispatch_time_t start;
	uint64_t timeout;
	uint64_t interval;
	
	dispatch_source_t timer;
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue eventHandler:(dispatch_block_t)block
{
	if ((self = [super init]))
	{
		timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
		dispatch_source_set_event_handler(timer, block);
		
		isStarted = NO;
	}
	return self;
}

- (void)dealloc
{
	[self cancel];
}

- (void)startWithTimeout:(NSTimeInterval)inTimeout interval:(NSTimeInterval)inInterval
{
	if (isStarted)
	{
		return;
	}
	
	start = dispatch_time(DISPATCH_TIME_NOW, 0);
	timeout = (inTimeout * NSEC_PER_SEC);
	interval = (inInterval > 0.0) ? (inInterval * NSEC_PER_SEC) : DISPATCH_TIME_FOREVER;
	
	dispatch_source_set_timer(timer, dispatch_time(start, timeout), interval, 0);
	dispatch_resume(timer);
	
	isStarted = YES;
}

- (void)updateTimeout:(NSTimeInterval)inTimeout fromOriginalStartTime:(BOOL)useOriginalStartTime
{
	if (!isStarted)
	{
		return;
	}
	
	if (!useOriginalStartTime) {
		start = dispatch_time(DISPATCH_TIME_NOW, 0);
	}
	timeout = (inTimeout * NSEC_PER_SEC);
	
	dispatch_source_set_timer(timer, dispatch_time(start, timeout), interval, 0);
}

- (void)cancel
{
	if (timer)
	{
		dispatch_source_cancel(timer);
		#if !OS_OBJECT_USE_OBJC
		dispatch_release(timer);
		#endif
		timer = NULL;
	}
}

@end
