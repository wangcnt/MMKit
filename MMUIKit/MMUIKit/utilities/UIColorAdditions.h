//
//  UIColorAdditions.h
//  QTime
//
//  Created by Mark on 15/7/16.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (instancetype)randomColor;
+ (instancetype)colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;
+ (instancetype)colorWithHex:(uint32_t)hex;
+ (instancetype)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)gradientColorFromColor:(UIColor *)color1 toColor:(UIColor *)color2 withHeight:(CGFloat)height;

+ (UIColor *)pixelColorInImage:(UIImage *)image atPoint:(CGPoint)point;

@end
