//
//  QTBadgeView.h
//  QTUIKit
//
//  Created by Mark on 15/7/1.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <QTUIKit/QTUIKit.h>

typedef enum
{
    QTBadgeTypeRedDot,
    QTBadgeTypeNumber,
    QTBadgeTypeImage
}QTBadgeType;

@interface QTBadgeView : QTView

@property (nonatomic, strong) UIColor             *tintColor;

@property (nonatomic, strong) UIColor             *badgeColor;

@property (nonatomic, strong) UIFont              *font;

@property (nonatomic, assign) float                maxWidth;

@property (nonatomic, strong) NSString            *badge;

- (void)setBadge:(NSString *)badge animated:(BOOL)animated;

@end
