//
//  UITextFieldAdditions.m
//  MMUIKit
//
//  Created by Mark on 2018/4/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "UITextFieldAdditions.h"

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UITextFieldAdditions)

@implementation UITextField (Additions)

- (void)selectAll {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *textRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    self.selectedTextRange = textRange;
}

@end
