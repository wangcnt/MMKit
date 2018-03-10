//
//  UIButtonAdditions.h
//  MMUIKit
//
//  Created by Mark on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (Additions)

- (void)setTouchUpInsideHandler:(void (^)(UIButton *button))handler;

@end
