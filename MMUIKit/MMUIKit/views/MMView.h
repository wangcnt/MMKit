//
//  MMView.h
//  MMime
//
//  Created by Mark on 15/6/24.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewAdditions.h"
#import "UIResponderAdditions.h"

@interface MMView : UIView

@property (nonatomic, assign) UIEdgeInsets  contentsEdges;      ///< 子控件与self的四边边距
@property (nonatomic, assign) CGSize contentsDistance;     ///< 子控件之间在横纵向间距

@end
