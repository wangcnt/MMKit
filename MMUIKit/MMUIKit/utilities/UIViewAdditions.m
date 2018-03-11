//  UIViewAdditions.m
//  QTTime
//
//  Created by Mark on 15/5/26.
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
    BOOL shouldStop;
    [self enumerateSubviewsRecursively:YES shouldStop:&shouldStop usingBlock:^(UIView *subview, BOOL *stop) {
        if([subview isKindOfClass:clazz]) {
            target = subview;
            *stop = YES;
        }
    }];
    return target;
}

- (void)enumerateSubviewsRecursively:(BOOL)recursively usingBlock:(void (^)(UIView *subview, BOOL *stop))block {
    BOOL shouldStop = NO;
    [self enumerateSubviewsRecursively:recursively shouldStop:&shouldStop usingBlock:block];
}

- (void)enumerateSubviewsRecursively:(BOOL)recursively shouldStop:(BOOL *)shouldStop usingBlock:(void (^)(UIView *subview, BOOL *stop))block {
    if(!block) return;
    for(UIView *subview in self.subviews) {
        if(*shouldStop || !recursively) {
            break;
        }
        block(subview, shouldStop);
        if(*shouldStop || !recursively) {
            break;
        }
        [subview enumerateSubviewsRecursively:recursively shouldStop:shouldStop usingBlock:block];
    }
}

- (NSString *)subhierarchyString {
    NSMutableString *result = [NSMutableString string];
    [self saveSubhierarchyWithView:self level:0 intoString:result];
    return result;
}

- (void)saveSubhierarchyWithView:(UIView *)view level:(int)level intoString:(NSMutableString *)result  {
    [result appendString:@"\n"];
    NSMutableString *space = [[NSMutableString alloc] initWithCapacity:4];
    for(int i=0; i<level; i++) {
        [result appendString:@"|---"];
    }
    [result appendFormat:@"%@%@-%d.%d.%d.%d-%zd", space, NSStringFromClass(view.class), (int)view.x, (int)view.y, (int)view.width, (int)view.height, view.tag];
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        [self saveSubhierarchyWithView:subview level:level+1 intoString:result];
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

