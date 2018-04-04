 //
//  MMUIInlines.h
//  MMUIKit
//
//  Created by Mark on 2018/2/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#ifndef MMUIInlines_h
#define MMUIInlines_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static inline BOOL mm_is_iphone() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

static inline BOOL mm_is_ipad() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

static inline BOOL mm_device_is_iphone_x() {
    return CGSizeEqualToSize(CGSizeMake(1125, 2436), [UIScreen mainScreen].currentMode.size);
}

static inline void mm_remove_keyboard() {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

static inline float mm_system_version() {
    return [UIDevice currentDevice].systemVersion.floatValue;
}

static inline float mm_system_version_is_less_than(float version) {
    return mm_system_version() < version;
}

static inline float mm_system_version_is_not_less_than(float version) {
    return mm_system_version() >= version;
}

static inline float mm_system_version_is_greater_than(float version) {
    return mm_system_version() > version;
}

static inline float mm_system_version_is_not_greater_than(float version) {
    return mm_system_version() <= version;
}

static inline float mm_system_version_is_equal(float version) {
    return mm_system_version() == version;
}

static inline UIApplication *mm_application() {
    return [UIApplication sharedApplication];
}

static inline id<UIApplicationDelegate> mm_app_delegate() {
    return mm_application().delegate;
}

static inline UIWindow *mm_main_window() {
    return mm_app_delegate().window;
}

static inline UIViewController *mm_root_controller() {
    return mm_main_window().rootViewController;
}

static inline CGFloat mm_screen_scale() {
    return [UIScreen mainScreen].scale;
}

static inline CGSize mm_screen_size() {
    return [UIScreen mainScreen].bounds.size;
}

static inline float mm_screen_width() {
    return [UIScreen mainScreen].bounds.size.width;
}

static inline float mm_screen_height() {
    return [UIScreen mainScreen].bounds.size.height;
}

static inline CGPoint mm_frame_center(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

static inline CGFloat mm_distance_between_points(CGPoint p1, CGPoint p2) {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

static inline CGSize mm_size_fits_in_size(CGSize size, CGSize maxSize) {
    if(CGSizeEqualToSize(CGSizeZero, maxSize))  maxSize = [UIScreen mainScreen].bounds.size;
    
    if(size.width > maxSize.width) {
        size.width = maxSize.width;
        size.height = maxSize.width * size.height / size.width;
    }
    
    if(size.height > maxSize.height){
        size.height = maxSize.height;
        size.width = maxSize.height * size.width / size.height;;
    }
    
    return size;
}

static inline CGFloat mm_distance_from_point_to_rect(CGPoint p, CGRect r) {
    r = CGRectStandardize(r);
    if (CGRectContainsPoint(r, p)) return 0;
    CGFloat distV, distH;
    if (CGRectGetMinY(r) <= p.y && p.y <= CGRectGetMaxY(r)) {
        distV = 0;
    } else {
        distV = p.y < CGRectGetMinY(r) ? CGRectGetMinY(r) - p.y : p.y - CGRectGetMaxY(r);
    }
    if (CGRectGetMinX(r) <= p.x && p.x <= CGRectGetMaxX(r)) {
        distH = 0;
    } else {
        distH = p.x < CGRectGetMinX(r) ? CGRectGetMinX(r) - p.x : p.x - CGRectGetMaxX(r);
    }
    return MAX(distV, distH);
}

/// Create an `ARGB` Bitmap context. Returns NULL if an error occurs.
///
/// @discussion The function is same as UIGraphicsBeginImageContextWithOptions(),
/// but it doesn't push the context to UIGraphic, so you can retain the context for reuse.
static inline CGContextRef YYCGContextCreateARGBBitmapContext(CGSize size, BOOL opaque, CGFloat scale) {
    size_t width = ceil(size.width * scale);
    size_t height = ceil(size.height * scale);
    if (width < 1 || height < 1) return NULL;
    
    //pre-multiplied ARGB, 8-bits per component
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGImageAlphaInfo alphaInfo = (opaque ? kCGImageAlphaNoneSkipFirst : kCGImageAlphaPremultipliedFirst);
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, kCGBitmapByteOrderDefault | alphaInfo);
    CGColorSpaceRelease(space);
    if (context) {
        CGContextTranslateCTM(context, 0, height);
        CGContextScaleCTM(context, scale, -scale);
    }
    return context;
}

/// Create a `DeviceGray` Bitmap context. Returns NULL if an error occurs.
static inline CGContextRef YYCGContextCreateGrayBitmapContext(CGSize size, CGFloat scale) {
    size_t width = ceil(size.width * scale);
    size_t height = ceil(size.height * scale);
    if (width < 1 || height < 1) return NULL;
    
    //DeviceGray, 8-bits per component
    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    CGImageAlphaInfo alphaInfo = kCGImageAlphaNone;
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, kCGBitmapByteOrderDefault | alphaInfo);
    CGColorSpaceRelease(space);
    if (context) {
        CGContextTranslateCTM(context, 0, height);
        CGContextScaleCTM(context, scale, -scale);
    }
    return context;
}

/**
 Returns a rectangle to fit the @param rect with specified content mode.
 @param rect The constrant rect
 @param size The content size
 @param mode The content mode
 @return A rectangle for the given content mode.
 @discussion UIViewContentModeRedraw is same as UIViewContentModeScaleToFill.
 */
static inline CGRect mm_rect_fit_with_content_mode(CGRect rect, CGSize size, UIViewContentMode mode) {
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (mode) {
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (mode == UIViewContentModeScaleAspectFit) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        } break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        } break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        } break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
        default: {
            rect = rect;
        }
    }
    return rect;
}

static inline UIColor *mm_clear_color()       { return [UIColor clearColor]; }
static inline UIColor *mm_blue_color()        { return [UIColor blueColor]; }
static inline UIColor *mm_red_color()         { return [UIColor redColor]; }
static inline UIColor *mm_black_color()       { return [UIColor blackColor]; }
static inline UIColor *mm_brown_color()       { return [UIColor brownColor]; }
static inline UIColor *mm_white_color()       { return [UIColor whiteColor]; }
static inline UIColor *mm_green_color()       { return [UIColor greenColor]; }
static inline UIColor *mm_orange_color()      { return [UIColor orangeColor]; }
static inline UIColor *mm_yellow_color()      { return [UIColor yellowColor]; }
static inline UIColor *mm_magenta_color()     { return [UIColor magentaColor]; }
static inline UIColor *mm_cyan_color()        { return [UIColor cyanColor]; }
static inline UIColor *mm_purple_color()      { return [UIColor purpleColor]; }
static inline UIColor *mm_graylight_color()   { return [UIColor lightGrayColor]; }
static inline UIColor *mm_graydark_color()    { return [UIColor darkGrayColor]; }

static inline UIColor *mm_random_color()      {
    return [UIColor colorWithRed:(float)(arc4random()%1000)/1000.0 green:(float)(arc4random()%1000)/1000.0 blue:(float)(arc4random()%1000)/1000.0 alpha:(float)(arc4random()%1000)/1000.0];
}

static inline UIColor *mm_rgba_color(r, g, b, a)  {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

static inline UIColor *mm_hex_color(hex) {
    return [UIColor colorWithRed:((hex>>16)&0xFF)/255.0 green:((hex>>8)&0xFF)/255.0 blue:(hex&0xFF)/255.0 alpha:1.0];
}

#endif /* MMUIInlines_h */
