//
//  MMBadgeView.h
//  MMUIKit
//
//  Created by Mark on 15/7/1.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <MMUIKit/MMUIKit.h>

#import "UIViewAdditions.h"
#import "UIResponderAdditions.h"

typedef enum
{
    MMBadgeTypeRedDot,
    MMBadgeTypeNumber,
    MMBadgeTypeImage
}MMBadgeType;

@interface MMBadgeView : MMView

@property (nonatomic, strong) UIColor             *tintColor;

@property (nonatomic, strong) UIColor             *badgeColor;

@property (nonatomic, strong) UIFont              *font;

@property (nonatomic, assign) float                maxWidth;

@property (nonatomic, strong) NSString            *badge;

- (void)setBadge:(NSString *)badge animated:(BOOL)animated;

@end
