//
//  UIViewAdditions.h
//  QTTime
//
//  Created by WangQiang on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(MMFrame)

- (CGPoint)original;
- (void)setOrigin:(CGPoint)origin;

- (float)x;
- (void)setX:(float)x;

- (float)y;
- (void)setY:(float)y;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (float)width;
- (void)setWidth:(float)width;

- (float)height;
- (void)setHeight:(float)height;

- (float)maxX;
- (void)setMaxX:(float)maxX;

- (float)maxY;
- (void)setMaxY:(float)maxY;

- (float)centerX;
- (void)setCenterX:(float)centerX;

- (float)centerY;
- (void)setCenterY:(float)centerY;

@end


@interface UIView (MMUtilities)

- (UIViewController *)belongedViewController;   ///< 找出直属的UIViewController

- (UIView *)findSubviewForClass:(Class)clazz;   ///< 找出该视图所有的子视图中的指定class的视图

- (void)enumerateSubviewsUsingBlock:(void (^)(UIView *subview, BOOL *stop))block;    ///< 遍历所有的子视图

- (void)printSubhierarchy;  ///< 打印视图的所有的子层级结构

@end

@interface UIView (MMAnimations)

- (void)wobble; ///< 抖动

@end


@interface UIView (MMVisuals)

- (void)setRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

@end
