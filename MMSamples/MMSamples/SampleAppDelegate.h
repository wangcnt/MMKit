//
//  SampleAppDelegate.h
//  MMSamples
//
//  Created by Mark on 2018/4/7.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMUIKit/MMUIKit.h>

@interface SampleAppDelegate : MMAppDelegate

@property (nonatomic, copy) void (^haha)(NSError *error);

- (void)showLaunchOptions;
- (void)showLaunchOptions:(NSDictionary *)launchOptions;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
