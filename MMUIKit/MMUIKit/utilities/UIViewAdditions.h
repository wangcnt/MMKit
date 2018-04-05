//
//  UIViewAdditions.h
//  QTTime
//
//  Created by Mark on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIResponderAdditions.h"

@interface UIView (MMFrame)

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
- (UIView *)findSubviewForClass:(Class)clazz;   ///< 找出该视图所有的子视图中的指定class的第一個视图
- (void)enumerateSubviewsRecursively:(BOOL)recursively usingBlock:(void (^)(UIView *subview, BOOL *stop))block;    ///< 遍历所有的子视图，可配置是否遞歸遍歷所有的子視圖，並可以隨時停止遍歷

- (NSString *)subhierarchyString;

@end

@interface UIView (MMAnimations)

- (void)wobble; ///< 抖动

@end

@interface UIView (Snapshot)

- (UIImage *)imageSnapshot;
- (UIImage *)imageSnapshotAfterScreenUpdates:(BOOL)afterUpdates;
- (NSData *)pdfSnapshot;

@end

@interface UIView (Corner)

- (void)setRoundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;    ///< Shoulld -displayCorners in -layoutSubviews
- (void)displayCorners;

@end
