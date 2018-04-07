//
//  MMAppDelegate.h
//  MMUIKit
//
//  Created by Mark on 2018/4/7.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIApplicationAdditions.h"
#import "UIResponderAdditions.h"

@interface MMAppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *_window;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL supportsShakingToEdit;

@end
