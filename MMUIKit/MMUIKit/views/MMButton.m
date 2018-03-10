//
//  MMButton.m
//  MMime
//
//  Created by Mark on 15/6/12.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMButton.h"

@implementation MMButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect insetedRect = UIEdgeInsetsInsetRect(self.bounds, self.eventableInset);
    return CGRectContainsPoint(insetedRect, point);
}

@end
