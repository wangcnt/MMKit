//
//  UILabelAdditions.m
//  MMUIKit
//
//  Created by Mark on 2018/3/10.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "UILabelAdditions.h"
#import <CoreText/CoreText.h>

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UILabelAdditions)

@implementation UILabel (Additions)

- (void)setColumnSpace:(CGFloat)columnSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
}

- (void)setRowSpace:(CGFloat)rowSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

@end
