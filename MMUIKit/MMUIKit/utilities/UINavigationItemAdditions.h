//
//  UINavigationItemAdditions.h
//  QTTime
//
//  Created by Mark on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

/**
 * 解决iOS7 UIBarButtonItem右移错位问题
 *
 */

#import <Foundation/Foundation.h>

@interface UINavigationItem(Space)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem indent:(float)indent;

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem indent:(float)indent;

@end
