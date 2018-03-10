//
//  UIButtonAdditions.m
//  MMUIKit
//
//  Created by Mark on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "UIButtonAdditions.h"
#import <objc/runtime.h>
#import <MMFoundation/MMDefines.h>

define_string(UIButtonTouchUpInsideHandlerKey)

@implementation UIButton (Additions)

- (void)setTouchUpInsideHandler:(void (^)(UIButton *button))handler {
    objc_setAssociatedObject(self, &UIButtonTouchUpInsideHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(touchUpInsideWithButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInsideWithButton:(UIButton *)btn {
    void (^block)(UIButton *) = objc_getAssociatedObject(self, &UIButtonTouchUpInsideHandlerKey);
    if(block) {
        block(self);
    }
}

@end
