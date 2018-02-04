//
//  MMView.h
//  MMime
//
//  Created by Mark on 15/6/24.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMView : UIView

@property (nonatomic, assign) UIEdgeInsets  contentsEdges;      ///< 子控件与self的四边边距

@property (nonatomic, assign) CGPoint       contentsOffset;     ///< 子控件之间在横纵向间距

- (void)reloadData;

@end
