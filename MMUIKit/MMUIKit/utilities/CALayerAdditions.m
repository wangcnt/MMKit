//
//  CALayerAdditions.m
//  MMUIKit
//
//  Created by Mark on 2018/3/10.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "CALayerAdditions.h"

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(CALayerAdditions)

@implementation CALayer (Additions)

- (void)shake{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat shakeWidth = 16;
    keyAnimation.values = @[@(-shakeWidth),@(0),@(shakeWidth),@(0),@(-shakeWidth),@(0),@(shakeWidth),@(0)];
    //时长
    keyAnimation.duration = .1f;
    //重复
    keyAnimation.repeatCount =2;
    //移除
    keyAnimation.removedOnCompletion = YES;
    
    [self addAnimation:keyAnimation forKey:@"shake"];
}

- (void)pauseAnimations
{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumeAnimations {
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

@end
