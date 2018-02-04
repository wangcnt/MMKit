//
//  UIApplicationAdditions.m
//  MMUIKit
//
//  Created by WangQiang on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "UIApplicationAdditions.h"

@implementation UIApplication(Additions)

@end


@implementation UIApplication (JKApplicationSize)

- (NSString *)applicationSize {
    unsigned long long docSize   =  [self folderSizeAtPath:[self documentPath]];
    unsigned long long libSize   =  [self folderSizeAtPath:[self libraryPath]];
    unsigned long long cacheSize =  [self folderSizeAtPath:[self cachePath]];
    
    unsigned long long total = docSize + libSize + cacheSize;
    
    NSString *totalSize = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    
    return totalSize;
}

- (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    
    return basePath;
}

- (NSString *)libraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    
    return basePath;
}

- (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    
    return basePath;
}



-(unsigned long long)folderSizeAtPath:(NSString *)folderPath
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long size = 0;
    NSString *path = @"";
    NSDictionary *fileAttributes = nil;
    while (file = [contentsEnumurator nextObject])
    {
        path = [folderPath stringByAppendingPathComponent:file];
        
        fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        
        size += [fileAttributes[NSFileSize ] intValue];
    }
    
    return size;
}

@end
