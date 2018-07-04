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

#import "CGUtilities.h"

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

static inline float mm_screen_width() {
    return [UIScreen mainScreen].bounds.size.width;
}

static inline float mm_screen_height() {
    return [UIScreen mainScreen].bounds.size.height;
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

static inline UIColor *mm_rgba_color(float r, float g, float b, float a)  {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

static inline UIColor *mm_hex_color(NSInteger hex) {
    return [UIColor colorWithRed:((hex>>16)&0xFF)/255.0 green:((hex>>8)&0xFF)/255.0 blue:(hex&0xFF)/255.0 alpha:1.0];
}

#endif /* MMUIInlines_h */
