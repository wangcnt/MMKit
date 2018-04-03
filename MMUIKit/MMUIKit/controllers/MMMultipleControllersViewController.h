//
//  MMMultiSubcontrollersViewController.h
//  MMUIKit
//
//  Created by Mark on 16/3/17.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <MMUIKit/MMUIKit.h>

typedef void(^MMMultipleControllersTransitionCompletion)(UIViewController *fromViewController, UIViewController *toViewController, BOOL finished);


@interface MMMultipleControllersViewController : MMViewController

@property (nonatomic, strong, readonly) UIViewController *currentViewController;
@property (nonatomic, assign) NSInteger currentIndex;                   ///< 只能取值，对于设值暂不维护
@property (nonatomic, strong, readonly) UIScrollView *containerScrollView;  ///< 已经监听scrollViewDidEndDecelerating:方法，需要继续监听需要调用super的方法

/**
 *  处理转场的操作，截屏等
 *
 *  @param from       from description
 *  @param to         to description
 *  @param completion completion description
 */
- (void)transitionViewControllerFrom:(UIViewController *)from toController:(UIViewController *)to completion:(MMMultipleControllersTransitionCompletion)completion;

/**
 *  完成转场后的回调
 *
 *  @param from     from description
 *  @param to       to description
 *  @param finished finished description
 */
- (void)didTransitionFromViewController:(UIViewController *)from toViewController:(UIViewController *)to finished:(BOOL)finished;

- (void)addChildViewController:(UIViewController *)childController;

@end
