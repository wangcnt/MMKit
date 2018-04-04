//
//  UITabBarControllerAdditions.m
//  QTime
//
//  Created by Mark on 15/6/28.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UITabBarControllerAdditions.h"

#define k_size_screen       [UIScreen mainScreen].bounds.size

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UITabBarControllerAdditions)

@interface UITabBarController()


@end

@implementation UITabBarController(Additions)

- (void)setTabBarHidded:(BOOL)hidden animated:(BOOL)animated {
    CGFloat y = k_size_screen.height - self.tabBar.frame.size.height;
    if(hidden) {
        y = k_size_screen.height;
    }
    CGRect frame = self.tabBar.frame;
    frame.origin.y = y;
    float duration = animated ? .25 : 0;
    [UIView animateWithDuration:duration animations:^{
        self.tabBar.frame = frame;
    }];
}

@end
