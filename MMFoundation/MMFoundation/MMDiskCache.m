//
//  MMDiskCache.m
//  MMFoundation
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMDiskCache.h"

#import "MMInlines.h"

@implementation MMDiskCache

@synthesize documentsPath = _documentsPath, temporaryPath = _temporaryPath, libraryPath = _libraryPath, cachesPath = _cachesPath;

- (instancetype)sharedInstance {
    static MMDiskCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[MMDiskCache alloc] init];
    });
    return cache;
}

- (NSString *)logPath {
    return [self pathWithIdentifier:nil directoryType:MMDiskCacheDirectoryTypeDocument fileType:MMDiskCacheFileTypeLog];
}

- (NSString *)pathWithIdentifier:(NSString *)identifier directoryType:(MMDiskCacheDirectoryType)directoryType fileType:(MMDiskCacheFileType)fileType {
    if(fileType == MMDiskCacheFileTypeLog) {
        return [mm_document_path() stringByAppendingString:[self filenameWithFileType:MMDiskCacheFileTypeLog]];
    } else {
        NSString *directory = [self pathWithDirectoryType:directoryType];
        if(!directory.length) {
            return nil;
        }
        NSString *filename = [self filenameWithFileType:fileType];
        if(filename.length) {
            if(!identifier.length) {
                identifier = @"public";
            }
            directory = [[directory stringByAppendingPathComponent:identifier] stringByAppendingPathComponent:filename];
            BOOL isDirectory;
            if(![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory] || !isDirectory) {
                NSError *error;
                if(![[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error] || error) {
                    return nil;
                }
            }
            return directory;
        }
        return nil;
    }
}

- (NSString *)documentsPath {
    if(!_documentsPath) {
        _documentsPath = mm_document_path();
    }
    return _documentsPath;
}

- (NSString *)temporaryPath {
    if(!_temporaryPath) {
        _temporaryPath = mm_temporary_path();
    }
    return _temporaryPath;
}

- (NSString *)cachesPath {
    if(!_cachesPath) {
        _cachesPath = mm_caches_path();
    }
    return _cachesPath;
}

- (NSString *)libraryPath {
    if(!_libraryPath) {
        _libraryPath = mm_library_path();
    }
    return _libraryPath;
}

- (NSString *)pathWithDirectoryType:(MMDiskCacheDirectoryType)type {
    return (type == MMDiskCacheDirectoryTypeDocument ? mm_document_path() :
            type == MMDiskCacheDirectoryTypeTemporary ? mm_temporary_path() :
            type == MMDiskCacheDirectoryTypeCache ? mm_caches_path() :
            type == MMDiskCacheDirectoryTypeLibrary ? mm_library_path() :
            nil);
}

- (NSString *)filenameWithFileType:(MMDiskCacheFileType)type {
    return (type == MMDiskCacheFileTypeLog ? @"app.log" :
            type == MMDiskCacheFileTypeDatabase ? @"db" :
            type == MMDiskCacheFileTypeImage ? @"image" :
            type == MMDiskCacheFileTypeVideo ? @"video" : @"public");
}

@end
