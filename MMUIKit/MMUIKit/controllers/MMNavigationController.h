//
//  MMNavigationController.h
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMNavigationController : UINavigationController

/**
 *  是否支持右滑pop事件
 */
@property (nonatomic, assign) BOOL               supportsRightSwipeToPop;

@property (nonatomic, strong) NSDictionary      *textAttributes;

@end
