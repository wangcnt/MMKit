//
//  MMTableView.m
//  MMUIKit
//
//  Created by Mark on 15/7/1.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMTableView.h"

@implementation MMTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if(self = [super initWithFrame:frame style:style]) {
        self.delaysContentTouches = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    // Because we set delaysContentTouches = NO, we return YES for UIButtons
    // so that scrolling works correctly when the scroll gesture
    // starts in the UIButtons.
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
