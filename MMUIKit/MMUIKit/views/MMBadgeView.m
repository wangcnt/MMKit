//
//  MMBadgeView.m
//  MMUIKit
//
//  Created by Mark on 15/7/1.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMBadgeView.h"

#import "UIViewAdditions.h"

@interface MMBadgeView() {
    float       _badgeHeight;
}

@end

@implementation MMBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _font = [UIFont systemFontOfSize:12];
        _badgeColor = [UIColor whiteColor];
        _tintColor = [UIColor redColor];
        _maxWidth = 30;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    if(_tintColor != tintColor) {
        _tintColor = tintColor;
        [self setNeedsDisplay];
    }
}

- (void)setFont:(UIFont *)font {
    if(_font != font) {
        _font = font;
        [self changeFrame];
        [self setNeedsDisplay];
    }
}

- (void)setBadgeColor:(UIColor *)badgeColor {
    if(_badgeColor != badgeColor) {
        _badgeColor = badgeColor;
        [self setNeedsDisplay];
    }
}

- (void)setBadge:(NSString *)badge {
    if(_badge != badge) {
        _badge = badge;
        [self changeFrame];
        [self setNeedsDisplay];
    }
}

- (void)setBadge:(NSString *)badge animated:(BOOL)animated {
    float duration = animated ? .25 : 0;
    [UIView animateWithDuration:duration animations:^{
        self.badge = badge;
    }];
}

- (void)changeFrame {
    CGRect rect = [_badge boundingRectWithSize:CGSizeMake(100, self.height)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSForegroundColorAttributeName : _font}
                                       context:nil];
    _badgeHeight     = rect.size.height;
    rect.origin.x    = self.x;
    rect.origin.y    = self.y;
    rect.size.width  = MIN(rect.size.width + 10.0, _maxWidth);
    rect.size.height = self.height;
    self.frame = rect;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(_badge.length == 0 || self.width <= 0 || self.height <= 0) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = self.height / 2;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:251 / 255.0 green:44 / 255.0 blue:55 / 255.0 alpha:1].CGColor);
    // 画左半圆
    CGContextAddArc(context, radius, radius, radius, M_PI / 2, -M_PI / 2, 0);
    // 右半圆
    CGContextAddArc(context, self.width - radius, radius, radius, - M_PI / 2, M_PI / 2, 0);
    CGContextFillPath(context);
    CGContextSetStrokeColorWithColor(context, _badgeColor.CGColor);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment     = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect r = self.bounds;
    r.origin.y    = (self.height - _badgeHeight ) / 2 - 1;
    r.size.height = _badgeHeight;
    [_badge drawInRect:r withAttributes:@{NSForegroundColorAttributeName : _badgeColor,
                                          NSFontAttributeName            : _font,
                                          NSParagraphStyleAttributeName  : style}];
}

@end
