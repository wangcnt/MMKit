//
//  UIButtonAdditions.m
//  MMUIKit
//
//  Created by Mark on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "UIButtonAdditions.h"
#import <objc/runtime.h>
#import <MMFoundation/MMDefines.h>

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UIButtonAdditions)

__c_stringify__(UIButtonTouchUpInsideHandlerKey)

@implementation UIButton (Additions)

- (void)setTouchUpInsideHandler:(void (^)(UIButton *button))handler {
    objc_setAssociatedObject(self, &UIButtonTouchUpInsideHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(touchUpInsideWithButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInsideWithButton:(UIButton *)btn {
    void (^block)(UIButton *) = objc_getAssociatedObject(self, &UIButtonTouchUpInsideHandlerKey);
    if(block) {
        block(self);
    }
}

- (void)setImagePosition:(UIButtonImagePosition)postion spacing:(CGFloat)spacing {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (postion) {
        case UIButtonImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case UIButtonImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case UIButtonImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case UIButtonImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
}

@end
