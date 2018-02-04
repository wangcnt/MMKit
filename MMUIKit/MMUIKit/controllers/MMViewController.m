//
//  MMViewController.h
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMViewController.h"

#import <UIKit/UIKit.h>

#import "MMConstants.h"
#import "MMNavigationController.h"
#import "UINavigationItemAdditions.h"

@interface MMViewController ()

@end

@implementation MMViewController

- (instancetype)init
{
    if(self = [super init])
    {
  
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationItem];
    
    _viewDidLoad = YES;
}

- (void)back
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(_poppingHandler)
    {
        _poppingHandler(self);
    }
    else if(   _viewControllerDelegate
            && [_viewControllerDelegate respondsToSelector:@selector(viewControllerWillBePopped:)])
    {
        [_viewControllerDelegate viewControllerWillBePopped:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationItem
{
    
}

- (void)setNavigationWithTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)jumpToViewController:(MMViewController *)controller withTargetTabBarItemAtIndex:(int)index
{
    if(self.tabBarController && index>=0 && index<self.tabBarController.viewControllers.count)
    {
        [self jumpToViewController:controller withTargetNavigationController:self.tabBarController.viewControllers[index]];
    }
}

- (void)jumpToViewController:(MMViewController *)controller withTargetNavigationController:(MMNavigationController *)navController
{
    // 1. 过滤异常跳转
    {
        if(!self.tabBarController)  return;
        
        if(![self.tabBarController.viewControllers containsObject:navController])   return;
        
        if(![navController isKindOfClass:[UINavigationController class]])    return;
        
        if(controller == self)      return;
    }
    
    UINavigationController *sourceNavController = self.navigationController;
    
    // 2. 跳转至navController所在的tabBarItem
    {
        if(sourceNavController != navController)
        {
            NSUInteger index = [self.tabBarController.viewControllers indexOfObject:navController];
            
            self.tabBarController.selectedIndex = index;
            
            [self.tabBarController tabBar:self.tabBarController.tabBar didSelectItem:navController.tabBarItem];
        }
    }
    
    // 3. push to secondary controller or pop to root controller
    {
        if(navController.viewControllers[0] == controller)
        {
            [navController popToRootViewControllerAnimated:YES];
        }
        else
        {
            controller.hidesBottomBarWhenPushed       = YES;
            
            if(navController == sourceNavController)
            {
                [navController setViewControllers:@[navController.viewControllers[0], controller] animated:YES];
            }
            else
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [navController setViewControllers:@[navController.viewControllers[0], controller] animated:YES];
                });
            }
        }
    }
    
    // 4. 原来的导航控制器必须返回根界面
    if(sourceNavController != navController)
    {
        [sourceNavController popToRootViewControllerAnimated:NO];
    }
}

- (void)dealloc
{
    NSLog(@"deallocated[%@]", NSStringFromClass(self.class));
}

@end




