//
//  UITabBarItemAdditions.m
//  QTime
//
//  Created by Mark on 15/6/17.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UITabBarItemAdditions.h"

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UITabBarItemAdditions)

@implementation UITabBarItem(iOS7)

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];  //这两个地方一定要加上
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    [item setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    return item;
}

@end
