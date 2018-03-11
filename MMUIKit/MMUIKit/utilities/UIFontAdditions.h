//
//  UIFontAdditions.h
//  MMUIKit
//
//  Created by Mark on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFont (MMCustom)

+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size;

+ (UIFont *)fontWithTTFAtURL:(NSURL *)URL size:(CGFloat)size;

@end
