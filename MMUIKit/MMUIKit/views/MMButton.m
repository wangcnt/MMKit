//
//  MMButton.m
//  MMime
//
//  Created by Mark on 15/6/12.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMButton.h"

@implementation MMButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    bounds.origin.x += self.eventableInset.left;
    bounds.origin.y += self.eventableInset.top;
    bounds.size.width -= (self.eventableInset.left+self.eventableInset.right);
    bounds.size.height -= (self.eventableInset.top+self.eventableInset.bottom);
    return CGRectContainsPoint(bounds, point);
}

@end
