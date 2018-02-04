//
//  UITabBarItemAdditions.h
//  QTime
//
//  Created by Mark on 15/6/17.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITabBarItem(iOS7)

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end

