//
//  UINavigationItemAdditions.m
//  QTTime
//
//  Created by WangQiang on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UINavigationItemAdditions.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UINavigationItem(Space)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem indent:(float)indent {
    if(!leftBarButtonItem)  return;
    indent = abs(indent);
    if(indent) {
        leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -indent, 0, indent);
    }
    self.leftBarButtonItem = leftBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem indent:(float)indent {
    if(!rightBarButtonItem) return;
    indent = abs(indent);
    if(indent) {
        rightBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -indent, 0, indent);
    }
    self.rightBarButtonItem = rightBarButtonItem;
}

@end
