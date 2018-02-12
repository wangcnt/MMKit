//
//  MMTabBarController.m
//  MMUIKit
//
//  Created by Mark on 16/11/18.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "MMTabBarController.h"

@interface MMTabBarController ()

@end

@implementation MMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------------------------------------------------------------
#pragma mark 屏幕旋转
- (BOOL)shouldAutorotate {
    return self.targetController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.targetController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.targetController.preferredInterfaceOrientationForPresentation;
}

- (UIViewController *)targetController {
    UIViewController *targetController = self.selectedViewController;
    if([targetController isKindOfClass:[UINavigationController class]]) {
        targetController = ((UINavigationController *)targetController).visibleViewController;
    }
    return targetController;
}

@end
