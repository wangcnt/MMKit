//
//  NSTimerAdditions.m
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "NSTimerAdditions.h"

#import "MMDefines.h"

__mm_synth_dummy_class__(NSTimerAdditions)

@implementation NSTimer (Additions)

- (void)pause {
    if (!self.isValid) {
        return ;
    }
    self.fireDate = NSDate.distantFuture;
}

- (void)resume {
    if (!self.isValid) {
        return ;
    }
    self.fireDate = [NSDate date];
}

- (void)resumeAfterTimeInterval:(NSTimeInterval)interval {
    if (!self.isValid) {
        return ;
    }
    self.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
}

@end
