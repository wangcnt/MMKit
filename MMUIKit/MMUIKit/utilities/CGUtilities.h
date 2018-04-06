//
//  CGUtilities.h
//  MMUIKit
//
//  Created by Mark on 2018/4/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static inline CGFloat mm_screen_scale() {
    return [UIScreen mainScreen].scale;
}

static inline CGSize mm_screen_size() {
    return [UIScreen mainScreen].bounds.size;
}

/// Returns the area of the rectangle.
static inline CGFloat CGRectGetArea(CGRect rect) {
    if (CGRectIsNull(rect)) return 0;
    rect = CGRectStandardize(rect);
    return rect.size.width * rect.size.height;
}

CGPoint CGFrameGetCenter(CGRect rect);

CGFloat CGPointGetDistanceToPoint(CGPoint p1, CGPoint p2);

CGSize CGSizeFitsInSize(CGSize size, CGSize maxSize);

CGFloat CGPointGetDistanceToRect(CGPoint p, CGRect r);  ///< Returns the minmium distance between a point to a rectangle.

/// Create an `ARGB` Bitmap context. Returns NULL if an error occurs.
///
/// @discussion The function is same as UIGraphicsBeginImageContextWithOptions(),
/// but it doesn't push the context to UIGraphic, so you can retain the context for reuse.
CGContextRef CGContextCreateARGBBitmapContext(CGSize size, BOOL opaque, CGFloat scale);

CGContextRef CGContextCreateGrayBitmapContext(CGSize size, CGFloat scale); ///< Create a `DeviceGray` Bitmap context. Returns NULL if an error occurs.

CGRect CGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);

NS_ASSUME_NONNULL_END
