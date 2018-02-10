//
//  MMNavigationController.m
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMNavigationController.h"

#import "UITabBarControllerAdditions.h"

@interface MMNavigationController ()

@end

@implementation MMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_textAttributes) {
        self.navigationBar.titleTextAttributes = _textAttributes;
    }
}

- (void)setTextAttributes:(NSDictionary *)textAttributes {
    _textAttributes = textAttributes;
    self.navigationBar.titleTextAttributes = _textAttributes;
}

#pragma mark -------------------------------------------------------------------
#pragma mark 屏幕旋转
- (BOOL)shouldAutorotate {
    return self.visibleViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.visibleViewController.supportedInterfaceOrientations;
}

@end
