//
//  UINavigationItemAdditions.h
//  QTTime
//
//  Created by WangQiang on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

/**
 * 解决iOS7 UIBarButtonItem右移错位问题
 *
 */

#import <Foundation/Foundation.h>

@interface UINavigationItem(Space)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem indented:(BOOL)indented;

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem indented:(BOOL)indented;

@end
