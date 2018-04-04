//
//  UISearchBarAdditions.m
//  QTTime
//
//  Created by Mark on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UISearchBarAdditions.h"

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UISearchBarAdditions)

@implementation UISearchBar(Additions)

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self.cancelButton setTitle:title forState:state];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [self.cancelButton setTitleColor:color forState:state];
}

- (UIButton *)cancelButton {
    __block UIButton *cancelButton = nil;
    NSArray *subviews = nil;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        subviews = [self.subviews[0] subviews];
    } else {
        subviews = self.subviews;
    }
    [subviews enumerateObjectsUsingBlock:^(id view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIButton class]]) {
            cancelButton = (UIButton *)view;
            *stop = YES;
        }
    }];
    return cancelButton;
}

@end
