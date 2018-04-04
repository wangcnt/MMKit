//
//  MMLabel.m
//  MMUIKit
//
//  Created by Mark on 15/11/16.
//  Copyright © 2015年 Mark. All rights reserved.
//

#import "MMLabel.h"



@implementation MMLabel

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = MMTextVerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(MMTextVerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case MMTextVerticalAlignmentTop: {
            textRect.origin.y = bounds.origin.y;
            break;
        }
        case MMTextVerticalAlignmentBottom: {
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        }
        default: {
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
        }
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
//    self.attributedText = nil;
    [super drawTextInRect:actualRect];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self displayCorners];
}

@end
