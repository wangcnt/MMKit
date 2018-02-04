//
//  UIActionSheetAdditions.m
//  QTime
//
//  Created by Mark on 15/6/24.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UIActionSheetAdditions.h"

#import "objc/runtime.h"

static NSString const *kUIActionSheetDidClickHandlerKey           = @"kUIActionSheetDidClickHandlerKey";

@interface UIActionSheet()
<UIActionSheetDelegate>

@end

@implementation UIActionSheet(Block)

- (instancetype)initWithTitle:(NSString *)title
                      handler:(UIActionSheetDidClickButtonHandler)handler
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIActionSheet *sheet = [self initWithTitle:title delegate:nil
                             cancelButtonTitle:nil
                        destructiveButtonTitle:nil
                             otherButtonTitles:nil];
    
    if (destructiveButtonTitle)
    {
        [self addButtonWithTitle:destructiveButtonTitle];
        
        self.destructiveButtonIndex = [self numberOfButtons] - 1;
    }
    
    va_list args;
    if (otherButtonTitles)
    {
        [self addButtonWithTitle:otherButtonTitles];
        
        va_start(args, otherButtonTitles);
        
        id eachObject;
        while ((eachObject = va_arg(args, id)))
        {
            [self addButtonWithTitle:eachObject];
        }
        
        va_end(args);
    }
    
    if (cancelButtonTitle)
    {
        [self addButtonWithTitle:cancelButtonTitle];
        
        self.cancelButtonIndex = [self numberOfButtons] - 1;
    }

    objc_setAssociatedObject(self, (__bridge const void *)kUIActionSheetDidClickHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    sheet.delegate = self;
    
    return sheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    actionSheet.delegate = nil;
    
    UIActionSheetDidClickButtonHandler handler = objc_getAssociatedObject(self, (__bridge const void *)kUIActionSheetDidClickHandlerKey);
    
    if(handler && buttonIndex+1 < actionSheet.numberOfButtons)
    {
        handler(actionSheet, buttonIndex);
    }
}

@end
