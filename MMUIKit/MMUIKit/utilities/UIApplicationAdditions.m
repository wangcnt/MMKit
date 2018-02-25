//
//  UIApplicationAdditions.m
//  MMUIKit
//
//  Created by Mark on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "UIApplicationAdditions.h"
#import <MMFoundation/MMFoundation.h>

@implementation UIApplication(Additions)

- (NSString *)applicationSize {
    unsigned long long docSize   =  [self folderSizeAtPath:[self documentPath]];
    unsigned long long libSize   =  [self folderSizeAtPath:[self libraryPath]];
    unsigned long long cacheSize =  [self folderSizeAtPath:[self cachePath]];
    unsigned long long total = docSize + libSize + cacheSize;
    NSString *totalSize = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    return totalSize;
}

- (NSString *)documentPath {
    return mm_document_path();
}

- (NSString *)libraryPath {
    return mm_library_path();
}

- (NSString *)cachePath {
    return mm_caches_path();
}

-(unsigned long long)folderSizeAtPath:(NSString *)folderPath {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    NSString *file;
    unsigned long long size = 0;
    NSString *path = @"";
    NSDictionary *fileAttributes = nil;
    while (file = [contentsEnumurator nextObject]) {
        path = [folderPath stringByAppendingPathComponent:file];
        fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        size += [fileAttributes[NSFileSize] longLongValue];
    }
    return size;
}

- (NSString *)applicationName {
    static NSString *appName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
        if (!appName) {
            appName = [[NSProcessInfo processInfo] processName];
        }
        if (!appName) {
            appName = @"";
        }
    });
    NSMutableArray *components = [NSMutableArray arrayWithArray:[appName componentsSeparatedByString:@"."]];
    [components filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF <> ''"]];
    return [components componentsJoinedByString:@"."];
}

@end
