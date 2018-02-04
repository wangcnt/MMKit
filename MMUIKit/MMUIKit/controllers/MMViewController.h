//
//  MMViewController.h
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MMNavigationController, MMViewController;

typedef void (^MMViewControllerWillBePoppedHandler)(MMViewController *controller);

@protocol MMViewControllerDelegate;

@interface MMViewController : UIViewController
{
    BOOL                _viewDidLoad;
}

@property (nonatomic, weak  ) id                                  viewControllerDelegate;   // 当前界面回退事件持有者

@property (nonatomic, strong) MMViewControllerWillBePoppedHandler poppingHandler;

@property (nonatomic, strong) NSMutableArray                     *tasks;        // 网络请求应该缓存起来？

@property (nonatomic, assign) BOOL                                canGoBack;    // 是否支持回退，默认第2页开始支持，但是如果这里设置了NO，则就不支持了

/**
 *  回退事件
 */
- (void)back;

/**
 *  刷新导航条
 */
- (void)setNavigationItem;

/**
 *  刷新导航条上标题
 *
 *  @param title title description
 */
- (void)setNavigationWithTitle:(NSString *)title;

/**
 *  当主框架是基于UITabBarController实现的时候，总会有个别情况下会需要跨UITabBar跳转界面
 *
 *  @param controller    controller description
 *  @param index         index description
 */
- (void)jumpToViewController:(MMViewController *)controller withTargetTabBarItemAtIndex:(int)index;

@end




@protocol MMViewControlerDelegate <NSObject>

/**
 *  当前controller在回退的时候，有时会需要通知上级界面做一些事情，
 *  比如刷新界面
 *
 *  @param controller current MMViewController
 */
@optional - (void)viewControllerWillBePopped:(MMViewController *)controller;

@end
