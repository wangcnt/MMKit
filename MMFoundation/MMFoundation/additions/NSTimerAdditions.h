//
//  NSTimerAdditions.h
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Additions)

- (void)pause;
- (void)resume;
- (void)resumeAfterTimeInterval:(NSTimeInterval)interval;

@end
