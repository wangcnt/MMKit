//
// Copyright 2011-2014 NimbusKit
// Originally written by Max Metral
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MMTextField.h"

@implementation MMTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeholderTextColor != nil || self.placeholderFont != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        if (self.placeholderTextColor) {
            [self.placeholderTextColor setFill];
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        paragraphStyle.alignment = self.textAlignment;
        NSDictionary *attributes = @{NSFontAttributeName : (self.placeholderFont ? self.placeholderFont : self.font),
                                     NSParagraphStyleAttributeName : paragraphStyle
                                     };
        [self.placeholder drawInRect:rect withAttributes:attributes];
        CGContextRestoreGState(context);
    } else {
        [super drawPlaceholderInRect:rect];
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.textInsets)) {
        return [super editingRectForBounds:bounds];
    }
    return UIEdgeInsetsInsetRect(bounds, self.textInsets);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.textInsets)) {
        return [super textRectForBounds:bounds];
    }
    return UIEdgeInsetsInsetRect(bounds, self.textInsets);
}



@end
