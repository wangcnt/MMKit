//
//  WQConstants.h
//  LocalNotifier
//
//  Created by Mark on 14/11/23.
//  Copyright (c) 2014年 Mark Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -------------------------------------------------------------------
#pragma mark 方法
#define func_remove_keyboard()                  [[UIApplication sharedApplication].keyWindow endEditing:YES]
#define _document_path()

#pragma mark -------------------------------------------------------------------
#pragma mark 重要应用对象获取
#define k_app_delegate                          [UIApplication sharedApplication].delegate
#define k_user_defaults                         [NSUserDefaults standardUserDefaults]
#define k_notification_center                   [NSNotificationCenter defaultCenter]

#define func_get_navigation_bar()               self.navigationController.navigationBar
#define func_get_tab_bar()                      self.tabBarController.tabBar

#pragma mark -------------------------------------------------------------------
#pragma mark 应用属性
#define func_get_bundle_version()               [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]

#pragma mark -------------------------------------------------------------------
#pragma mark 常用表达式
#define k_system_version                        [UIDevice currentDevice].systemVersion.floatValue
#define k_system_version_is_not_less_than_7     k_system_version >= 7.0
#define k_system_version_is_not_less_than_8     k_system_version >= 8.0

#define k_bounds_screen                         [UIScreen mainScreen].bounds
#define k_width_screen                          k_bounds_screen.size.width
#define k_height_screen                         k_bounds_screen.size.height
#define k_frame_status_bar                      [UIApplication sharedApplication].statusBarFrame
#define k_height_status_bar                     MIN(k_frame_status_bar.size.width, k_frame_status_bar.size.height)

#pragma mark -------------------------------------------------------------------
#pragma mark 颜色
#define k_color_clear                           [UIColor clearColor]
#define k_color_blue                            [UIColor blueColor]
#define k_color_red                             [UIColor redColor]
#define k_color_black                           [UIColor blackColor]
#define k_color_brown                           [UIColor brownColor]
#define k_color_white                           [UIColor whiteColor]
#define k_color_green                           [UIColor greenColor]
#define k_color_orange                          [UIColor orangeColor]
#define k_color_yellow                          [UIColor yellowColor]
#define k_color_magenta                         [UIColor magentaColor]
#define k_color_cyan                            [UIColor cyanColor]
#define k_color_purple                          [UIColor purpleColor]
#define k_color_gray_light                      [UIColor lightGrayColor]
#define k_color_gray_dark                       [UIColor darkGrayColor]

#define func_random_color()                     [UIColor colorWithRed:(float)(arc4random()%10000)/10000.0 green:(float)(arc4random()%10000)/10000.0 blue:(float)(arc4random()%10000)/10000.0 alpha:(float)(arc4random()%10000)/10000.0]

#define func_rgba_color(r, g, b, a)             [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define func_hex_color(hex)                     [UIColor colorWithRed:((hex>>16)&0xFF)/255.0 green:((hex>>8)&0xFF)/255.0 blue:(hex&0xFF)/255.0 alpha:1.0];

#pragma mark -------------------------------------------------------------------
#pragma mark 重要路径
#define k_directory_documents                   [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define k_directory_library                     [NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define k_directory_caches                      [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


