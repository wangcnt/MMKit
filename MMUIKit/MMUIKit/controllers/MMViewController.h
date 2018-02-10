//
//  MMViewController.h
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MMNavigationController, MMViewController;

@interface MMViewController : UIViewController

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

@end
