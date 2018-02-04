//
//  QTViewController.h
//  QTTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QTNavigationController, QTViewController;

typedef void (^QTViewControllerWillBePoppedHandler)(QTViewController *controller);

@protocol QTViewControllerDelegate;

@interface QTViewController : UIViewController

@property (nonatomic, weak  ) id                                  viewControllerDelegate;   // 当前界面回退事件持有者

@property (nonatomic, strong) QTViewControllerWillBePoppedHandler poppingHandler;

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
- (void)jumpToViewController:(QTViewController *)controller withTargetTabBarItemAtIndex:(int)index;

/**
 *  重新加载当前界面的数据
 *  
 *  没有网络时在界面中间会出现重新加载的按钮，点击重新加载则子类需要实现此方法，从服务器拉取数据并刷新
 */
- (void)resendRequest;

/**
 *  是否隐藏网络请求失败同时又没有本地缓存数据的提示
 *
 *  @param visible YES / NO
 */
- (void)setNonetworkingViewVisible:(BOOL)visible;

@end




@protocol QTViewControlerDelegate <NSObject>

/**
 *  当前controller在回退的时候，有时会需要通知上级界面做一些事情，
 *  比如刷新界面
 *
 *  @param controller current QTViewController
 */
@optional - (void)viewControllerWillBePopped:(QTViewController *)controller;

@end
