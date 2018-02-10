//  UIViewAdditions.m
//  QTTime
//
//  Created by WangQiang on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UIViewAdditions.h"

#define func_angel_to_randian(x)           x/180.0*M_PI

@implementation UIView(MMFrame)

//@dynamic x, y, width, height, original, size, maxX ,maxY;

- (CGPoint)original {
    return self.frame.origin;
}

- (float)x {
    return self.original.x;
}

- (float)y {
    return self.original.y;
}

- (CGSize)size {
    return self.frame.size;
}

- (float)width {
    return self.size.width;
}

- (float)height {
    return self.size.height;
}

- (float)maxX {
    return CGRectGetMaxX(self.frame);
}

- (float)maxY {
    return CGRectGetMaxY(self.frame);
}

- (float)centerX {
    return self.center.x;
}

- (float)centerY {
    return self.center.y;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect rect = {origin, self.frame.size};
    self.frame = rect;
}

- (void)setX:(float)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(float)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setSize:(CGSize)size {
    CGRect rect = {self.original, size};
    self.frame = rect;
}

- (void)setWidth:(float)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(float)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setMaxX:(float)maxX {
    self.width = maxX - self.x;
}

- (void)setMaxY:(float)maxY {
    self.height = maxY - self.y;
}

- (void)setCenterX:(float)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(float)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

@end

@implementation UIView (MMUtilities)

- (UIViewController *)belongedViewController {
    id nextResponser = self.nextResponder;
    while (nextResponser) {
        if([nextResponser isKindOfClass:[UIViewController class]]) {
            return nextResponser;
        }
        nextResponser = [nextResponser nextResponder];
    }
    return nil;
}

- (UIView *)findSubviewForClass:(Class)clazz {
    __block UIView *target = nil;
    BOOL shouldContinue;
    [self enumerateSubviewsRecursively:YES shouldContinue:&shouldContinue usingBlock:^(UIView *subview, BOOL *stop) {
        if([subview isKindOfClass:clazz]) {
            target = subview;
            *stop = YES;
        }
    }];
    return target;
}

- (void)enumerateSubviewsRecursively:(BOOL)recursively usingBlock:(void (^)(UIView *subview, BOOL *stop))block {
    BOOL shouldContinue;
    [self enumerateSubviewsRecursively:recursively shouldContinue:&shouldContinue usingBlock:block];
}

- (void)enumerateSubviewsRecursively:(BOOL)recursively shouldContinue:(BOOL *)shouldContinue usingBlock:(void (^)(UIView *subview, BOOL *stop))block {
    if(!block) return;
    for(UIView *subview in self.subviews) {
        block(subview, shouldContinue);
        if(shouldContinue && recursively) {
            [subview enumerateSubviewsRecursively:recursively shouldContinue:shouldContinue usingBlock:block];
        } else {
            break;
        }
    }
}

- (void)printSubhierarchy
{
    NSLog(@"====================================================================");
    [self printSubhierarchyWithView:self level:0];
    NSLog(@"====================================================================");
}

- (void)printSubhierarchyWithView:(UIView *)view level:(int)level {
    NSMutableString *space = [[NSMutableString alloc] initWithCapacity:4];
    for(int i=0; i<level; i++) {
        [space appendString:@"|---"];
    }
    NSLog(@"%@%@.%zd.%@", space, [view class], view.tag, view);
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        [self printSubhierarchyWithView:subview level:level+1];
    }];
}

@end


@implementation UIView (MMAnimations)

- (void)wobble {
    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
    
    anim.keyPath = @"transform.rotation";
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.2;
    anim.values = @[@(func_angel_to_randian(-7)),
                    @(func_angel_to_randian(7)),
                    @(func_angel_to_randian(-7))
                    ];
    [self.layer addAnimation:anim forKey:nil];
}

@end

@implementation UIView (MMVisuals)

- (void)setRoundedCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    CGRect rect = self.bounds;
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

@end
