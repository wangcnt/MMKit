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

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem indented:(BOOL)indented
{
    if(!leftBarButtonItem)  return;
    
    if(indented)
    {
        leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    }
    
    self.leftBarButtonItem = leftBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem indented:(BOOL)indented
{
    if(!rightBarButtonItem) return;
    
    if(indented)
    {
        rightBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    }
    
    self.rightBarButtonItem = rightBarButtonItem;
}

@end
