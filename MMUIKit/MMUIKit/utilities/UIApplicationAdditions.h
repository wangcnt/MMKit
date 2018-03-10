//
//  UIApplicationAdditions.h
//  MMUIKit
//
//  Created by Mark on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication(Additions)

- (NSString *)applicationSize;
- (NSString *)applicationName;

- (UIViewController *)currentViewController;
- (UINavigationController *)currentNavigatonController;

- (BOOL)rate;

@end
