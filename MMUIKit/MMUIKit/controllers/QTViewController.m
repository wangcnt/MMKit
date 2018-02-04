//
//  QTViewController.h
//  QTTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "QTViewController.h"

#import <UIKit/UIKit.h>

#import "QTConstants.h"
#import "QTNavigationController.h"
#import "UINavigationItemAdditions.h"

#import "QTNonetworkingView.h"

@interface QTViewController ()
<QTNonetworkingViewDelegate>
{
    QTNonetworkingView      *_nonetworkingView;
}
@end

@implementation QTViewController

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
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240./255.0 alpha:1];

    // 强制设置导航条左边回退按钮
    {        
        if([self.navigationController.viewControllers indexOfObject:self] >= 1)
        {
            UIImage *image = [UIImage imageNamed:@"p_btn_arrows_normal"];
            
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(back)];
            
            [self.navigationItem setLeftBarButtonItem:leftItem indented:YES];
        }
    }
    
    [self setNavigationItem];
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

- (void)jumpToViewController:(QTViewController *)controller withTargetTabBarItemAtIndex:(int)index
{
    if(self.tabBarController && index>=0 && index<self.tabBarController.viewControllers.count)
    {
        [self jumpToViewController:controller withTargetNavigationController:self.tabBarController.viewControllers[index]];
    }
}

- (void)jumpToViewController:(QTViewController *)controller withTargetNavigationController:(QTNavigationController *)navController
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

- (void)resendRequest
{
    //TODO: 子类实现
    NSLog(@"这里你需要重写一下resendRequest方法才能实现重新加载噢😁");
}

/**
 *  是否隐藏网络请求失败的提示
 *
 *  @param visible YES / NO
 */
- (void)setNonetworkingViewVisible:(BOOL)visible
{
    if(visible)
    {
        if(!_nonetworkingView)
        {
            _nonetworkingView = [[QTNonetworkingView alloc] initWithFrame:self.view.bounds];
            
            _nonetworkingView.delegate = self;
            
            _nonetworkingView.alpha = _nonetworkingView.userInteractionEnabled = NO;
            
            [self.view addSubview:_nonetworkingView];
            
            _nonetworkingView.center = self.view.center;
        }
        
        [self.view bringSubviewToFront:_nonetworkingView];
        
        _nonetworkingView.alpha = YES;
        _nonetworkingView.userInteractionEnabled = YES;
    }
    else
    {
        if(!_nonetworkingView)  return;
            
//        [self.view sendSubviewToBack:_nonetworkingView];
        
        _nonetworkingView.alpha = NO;
        _nonetworkingView.userInteractionEnabled = NO;
    }
}

- (void)dealloc
{
    NSLog(@"deallocated[%@]", NSStringFromClass(self.class));
}

#pragma mark ---------------------------------------------------------------------------------------
#pragma mark QTNonetworkingViewDelegate
- (void)nonetworkingViewNeedsReloading:(QTNonetworkingView *)view
{
    [self resendRequest];
}

@end




