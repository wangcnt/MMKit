//
//  UIFontAdditions.m
//  MMUIKit
//
//  Created by Mark on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "UIFontAdditions.h"

#import <CoreText/CoreText.h>

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UIFontAdditions)

@implementation UIFont (MMCustom)

+ (UIFont *)fontWithTTFAtURL:(NSURL *)URL size:(CGFloat)size{
    BOOL isLocalFile = [URL isFileURL];
    NSAssert(isLocalFile, @"TTF files may only be loaded from local file paths. Remote files must first be cached locally, this category does not handle such cases natively.\n\nIf, however, the provided URL is indeed a reference to a local file.\n\n1. Ensure it was created via a method such as [NSURL fileURLWithPath:] and NOT [NSURL URLWithString:].\n\n2. Ensure the URL returns YES to isFileURL.");
    if (!isLocalFile) {
        return [UIFont systemFontOfSize:size];
    }
    return [UIFont fontWithTTFAtPath:URL.path size:size];
}

+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size {
    BOOL extsis = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSAssert(extsis, @"The font at: \"%@\" was not found.", path);
    if (!extsis) {
        return [UIFont systemFontOfSize:size];
    }
    CFURLRef fontURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)path, kCFURLPOSIXPathStyle, false);;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithURL(fontURL);
    CFRelease(fontURL);
    CGFontRef graphicsFont = CGFontCreateWithDataProvider(dataProvider);
    CFRelease(dataProvider);
    CTFontRef smallFont = CTFontCreateWithGraphicsFont(graphicsFont, size, NULL, NULL);
    CFRelease(graphicsFont);
    UIFont *returnFont = (__bridge UIFont *)smallFont;
    CFRelease(smallFont);
    return returnFont;
}

@end
