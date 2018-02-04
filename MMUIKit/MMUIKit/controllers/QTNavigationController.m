//
//  QTNavigationController.m
//  QTTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "QTNavigationController.h"

#import "SloppySwiper.h"
#import "QTNavigationBar.h"
#import "UITabBarControllerAdditions.h"

@interface QTNavigationController ()
<UINavigationControllerDelegate>
{
    SloppySwiper                *_swiper;
}

@end

@implementation QTNavigationController

- (instancetype)init
{
    return [self initWithRootViewController:nil];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if(self = [super initWithNavigationBarClass:[QTNavigationBar class] toolbarClass:nil])
    {
        if(rootViewController)
        {
            self.viewControllers = @[rootViewController];
        }
        
        _textAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:20]};
        
        [self setSupportsRightSwipeToPop:YES];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(_textAttributes)
    {
        self.navigationBar.titleTextAttributes = _textAttributes;
    }
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray *controllers = [self controllersWillBePoppedAfterViewController:viewController];
    
    //如果不需要pop任何界面，那么不需要做任何事
    if(controllers.count == 0)
    {
        return nil;
    }
    
    [self setNavigationBarHidden:NO];
    
    UIViewController *rootController = self.viewControllers[0];
    
    //如果退到的界面是根界面，那么要显示出来底部UITabBar
    if(viewController == rootController)
    {
        rootController.hidesBottomBarWhenPushed = NO;
        
        [viewController.tabBarController setTabBarHidded:NO animated:NO];
    }
    
    [super popToViewController:viewController animated:animated];
    
    return controllers;
}

- (NSArray *)controllersWillBePoppedAfterViewController:(UIViewController *)controller
{
    NSUInteger index = [self.viewControllers indexOfObject:controller];
    if(index == NSNotFound)
    {
        return @[];
    }
    
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:5];
    
    for(++index; index < self.viewControllers.count; index++)
    {
        [controllers addObject:self.viewControllers[index]];
    }
    
    return controllers;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if(idx)
        {
            obj.hidesBottomBarWhenPushed = YES;
        }
    }];
    
    [super setViewControllers:viewControllers animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [self popToViewController:self.viewControllers[0] animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if(self.viewControllers.count <= 1)
    {
        return nil;
    }
    
    UIViewController *targetController = self.viewControllers[self.viewControllers.count-2];
    
    return [[self popToViewController:targetController animated:animated] lastObject];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 第二级界面开始隐藏掉底部tabBar
    if(self.viewControllers.count == 1)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [self setNavigationBarHidden:NO];
    
    [super pushViewController:viewController animated:animated];
}

- (void)setSupportsRightSwipeToPop:(BOOL)supportsRightSwipeToPop
{
    if(_supportsRightSwipeToPop != supportsRightSwipeToPop)
    {
        _supportsRightSwipeToPop = supportsRightSwipeToPop;
        
        if(_supportsRightSwipeToPop)
        {
            if(!_swiper)
            {
                _swiper = [[SloppySwiper alloc] initWithNavigationController:self];
            }
            
            self.delegate = _swiper;
        }
        else
        {
            if(_swiper)
            {
                _swiper.enabled = NO;
            }
        }
    }
}

@end
