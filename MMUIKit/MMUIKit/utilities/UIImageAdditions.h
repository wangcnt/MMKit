//
//  UIImageAdditions.h
//  QTTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(Additions)

+ (UIImage *)imageFromView:(UIView *)view;

- (UIImage *)compressToSize:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithOrientationUnfixedImage:(UIImage *)image;

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

#pragma mark -
#pragma mark 压缩，裁剪
+ (UIImage *)compressedImageWithImage:(UIImage *)image;
+ (UIImage *)compressedImageWithImage:(UIImage *)image maxKBSize:(double)maxKB;

+ (UIImage *)croppedImageWithImage:(UIImage *)image inSize:(CGSize)maxSize;

+ (CGSize)size:(CGSize)originalSize thatZoomsInside:(CGSize)maxSize;

@end
