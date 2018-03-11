//
//  NSBundleAdditions.m
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "NSBundleAdditions.h"

@implementation NSBundle (Additions)

- (NSString *)appIconPath {
    NSString *fullname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"] ;
    NSString *filename = [fullname stringByDeletingPathExtension] ;
    NSString *extension = fullname.pathExtension;
    return [[NSBundle mainBundle] pathForResource:filename ofType:extension] ;
}

@end
