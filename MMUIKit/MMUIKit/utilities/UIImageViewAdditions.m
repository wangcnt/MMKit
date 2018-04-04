//
//  UIImageViewAdditions.m
//  MMUIKit
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "UIImageViewAdditions.h"

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UIImageViewAdditions)

@implementation UIImageView (Additions)

- (UIImageView *)reflectedImageView {
    CGRect frame = self.frame;
    frame.origin.y += (frame.size.height + 1);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    self.clipsToBounds = TRUE;
    imageView.contentMode = self.contentMode;
    imageView.image = self.image;
    imageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    CALayer *layer = imageView.layer;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = layer.bounds;
    gradientLayer.position = CGPointMake(layer.bounds.size.width / 2, layer.bounds.size.height * 0.5);
    gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    gradientLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor]];
    
    layer.mask = gradientLayer;
    
    return imageView;
}

@end
