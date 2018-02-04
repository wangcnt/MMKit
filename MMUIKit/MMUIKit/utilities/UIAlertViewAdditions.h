//
//  UIAlertViewAdditions.h
//  QTime
//
//  Created by Mark on 15/6/17.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UIAlertViewDidClickButtonHandler)(UIAlertView *alertView, NSInteger index);

@interface UIAlertView(Block)
+ (void)showWithTitle:(NSString *)title message:(NSString *)message handler:(UIAlertViewDidClickButtonHandler)handler
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
