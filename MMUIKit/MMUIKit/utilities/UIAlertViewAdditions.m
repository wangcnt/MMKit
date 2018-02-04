//
//  UIAlertViewAdditions.m
//  QTime
//
//  Created by Mark on 15/6/17.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UIAlertViewAdditions.h"

#import "objc/runtime.h"

static NSString const *kUIAlertViewDidClickHandlerKey           = @"kUIAlertViewDidClickHandlerKey";

@interface UIAlertView()
<UIAlertViewDelegate>

@end

@implementation UIAlertView(Block)

+ (void)showWithTitle:(NSString *)title message:(NSString *)message handler:(UIAlertViewDidClickButtonHandler)handler
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];

    if(cancelButtonTitle.length > 0)
    {
        [alertView addButtonWithTitle:cancelButtonTitle];
    }
    
    va_list args;
    if (otherButtonTitles)
    {
        [alertView addButtonWithTitle:otherButtonTitles];
        
        va_start(args, otherButtonTitles);
        
        id eachObject;
        while ((eachObject = va_arg(args, id)))
        {
            [alertView addButtonWithTitle:eachObject];
        }
        
        va_end(args);
    }
    
    [alertView showWithHandler:handler];
}

- (void)showWithHandler:(UIAlertViewDidClickButtonHandler)handler
{
    objc_setAssociatedObject(self, (__bridge const void *)kUIAlertViewDidClickHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    self.delegate = self;
    
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertView.delegate = nil;
    
    UIAlertViewDidClickButtonHandler handler = objc_getAssociatedObject(self, (__bridge const void *)kUIAlertViewDidClickHandlerKey);
    
    if(handler)
    {
        handler(alertView, buttonIndex);
    }
}

@end
