//
//  UIBarButtonItemAdditions.h
//  MMUIKit
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UIBarButtonItemHandler)(UIBarButtonItem *item);

@interface UIBarButtonItem (Additions)
@property (nonatomic, copy) UIBarButtonItemHandler handler;
@end
