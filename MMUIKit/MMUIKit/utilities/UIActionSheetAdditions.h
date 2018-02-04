//
//  UIActionSheetAdditions.h
//  QTime
//
//  Created by Mark on 15/6/24.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UIActionSheetDidClickButtonHandler)(UIActionSheet *sheet, NSInteger index);

@interface UIActionSheet(Block)

- (instancetype)initWithTitle:(NSString *)title
                      handler:(UIActionSheetDidClickButtonHandler)handler
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
