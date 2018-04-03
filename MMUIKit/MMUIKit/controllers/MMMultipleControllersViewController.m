//
//  MMMultipleControllersViewController.m
//  MMUIKit
//
//  Created by Mark on 16/3/17.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "MMMultipleControllersViewController.h"

@interface MMMultipleControllersViewController() <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UIView *> *screenshotViewDictionary;

@end

@implementation MMMultipleControllersViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addSubviews];
}

- (void)addSubviews {
    _containerScrollView = [[UIScrollView alloc] init];
    _containerScrollView.frame = self.view.bounds;
    _containerScrollView.pagingEnabled = YES;
    _containerScrollView.alwaysBounceVertical = NO;
    _containerScrollView.delegate = self;
    [self.view addSubview:_containerScrollView];
}

- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    _containerScrollView.contentSize = CGSizeMake(_containerScrollView.bounds.size.width * self.childViewControllers.count, 0);
    // 设置初始化的控制器，默认第一个显示出来
    if (!_currentViewController) {
        childController.view.frame = _containerScrollView.bounds;
        _currentViewController = childController;
        [_containerScrollView addSubview:self.currentViewController.view];
    }
}

/**
 处理转场的操作，截屏等
 */
- (void)transitionViewControllerFrom:(UIViewController *)from toController:(UIViewController *)to completion:(void (^)(UIViewController *fromViewController, UIViewController *toViewController, BOOL finished))completion {
    if (!from || !to || from == to || to == _currentViewController) return;
    // 获取from的截屏
    UIView *screenshotView = [from.view snapshotViewAfterScreenUpdates:NO];
    NSUInteger currentIndex = [self.childViewControllers indexOfObject:from];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    UIView *oldShot = self.screenshotViewDictionary[indexPath];
    if (oldShot) {
        [oldShot removeFromSuperview];
    }
    
    self.screenshotViewDictionary[indexPath] = screenshotView;
    screenshotView.frame = from.view.frame;
    
    // 计算新界面的位置
    NSInteger toIndex = [self.childViewControllers indexOfObject:to];
    to.view.frame = CGRectMake(toIndex * _containerScrollView.frame.size.width,
                               0,
                               _containerScrollView.frame.size.width,
                               _containerScrollView.frame.size.height);
    
    __weak __typeof(self) weakedSelf = self;
    // 滚动到相应的位置
    [_containerScrollView setContentOffset:CGPointMake(toIndex * _containerScrollView.frame.size.width, 0) animated:YES];
    
    [to willMoveToParentViewController:self];
    [to isMovingToParentViewController];
    [_currentViewController isMovingFromParentViewController];
    
    [self transitionFromViewController:from
                      toViewController:to
                              duration:0
                               options:UIViewAnimationOptionCurveEaseInOut animations:^{
                               }
                            completion:^(BOOL finished) {
                                _currentViewController = to;
                                _currentIndex = toIndex;
                                [_containerScrollView addSubview:screenshotView];
                                [to didMoveToParentViewController:weakedSelf];
                                
                                if (completion) {
                                    completion(from, to, finished);
                                } else {
                                    [weakedSelf didTransitionFromViewController:from toViewController:to finished:finished];
                                }
                            }];
    
}

- (void)didTransitionFromViewController:(UIViewController *)from toViewController:(UIViewController *)to finished:(BOOL)finished {
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIViewController *to = self.childViewControllers[page];
    [self transitionViewControllerFrom:_currentViewController toController:to completion:nil];
}

#pragma mark - Getter Setter
- (NSMutableDictionary<NSIndexPath *,UIView *> *)screenshotViewDictionary {
    if (!_screenshotViewDictionary) {
        _screenshotViewDictionary = [NSMutableDictionary dictionary];
    }
    return _screenshotViewDictionary;
}

- (void)dealloc {
    _containerScrollView.delegate = nil;
}

@end
