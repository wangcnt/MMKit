//
//  MMNavigationBar.m
//
//  Created by Corey Roberts on 9/24/13.
//  Copyright (c) 2013 SpacePyro Inc. All rights reserved.
//

#import "MMNavigationBar.h"

@interface MMNavigationBar ()

@property (strong, nonatomic) CALayer *backgroundColorLayer;

@end


@implementation MMNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    if (   NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0
        || NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        return;
    }
    
    self.barStyle                     = UIBarStyleBlack;
    self.backgroundColorLayer         = [CALayer layer];
    self.backgroundColorLayer.opacity = 0.85f;
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    [super setBarTintColor:barTintColor];
    
    if (   NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0
        || NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        return;
    }
    
    if (self.backgroundColorLayer && !self.backgroundColorLayer.superlayer)
    {
        [self.layer addSublayer:self.backgroundColorLayer];
    }
    
    self.backgroundColorLayer.backgroundColor = barTintColor.CGColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.backgroundColorLayer)
    {
        [self.backgroundColorLayer removeFromSuperlayer];
        
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        self.backgroundColorLayer.frame = CGRectMake(0, -statusBarHeight,
                                                     CGRectGetWidth(self.frame),
                                                     statusBarHeight+CGRectGetHeight(self.frame));
        
        [self.layer insertSublayer:self.backgroundColorLayer atIndex:1];
    }
}

- (void)blurWithColor:(UIColor *)color
{
    self.barTintColor = color;
    
    self.translucent = YES;
}

- (void)blurWithImage:(UIImage *)image
{
    [self blurWithColor:[UIColor colorWithPatternImage:image]];
}


@end
