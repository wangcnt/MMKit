//
//  MMDiskCache.m
//  MMFoundation
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMDiskCache.h"

#import "MMDefines.h"
#import "NSFileManagerAdditions.h"

@implementation MMDiskCache

@synthesize documentsPath = _documentsPath, temporaryPath = _temporaryPath, libraryPath = _libraryPath, cachesPath = _cachesPath;

+ (instancetype)sharedInstance {
    static MMDiskCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[MMDiskCache alloc] init];
    });
    return cache;
}

- (NSString *)pathWithDirectoryMask:(MMDirectoryMask)mask account:(NSString *)account {
    return [self pathWithDirectoryMask:mask account:account module:nil];
}

- (NSString *)pathWithDirectoryMask:(MMDirectoryMask)mask account:(NSString *)account module:(NSString *)module {
    // eg. Documents/
    NSString *directory = [self directoryWithMask:mask];
    if(!directory.length) {
        return nil;
    }
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if(account.length) {
        // eg. Documents/users
        directory = [directory stringByAppendingPathComponent:@"users"];
        if(![fileManger createFolderAtPathIfNeeds:directory]) {
            return nil;
        }
        
        // eg. Documents/users/404298011
        directory = [directory stringByAppendingPathComponent:account];
        if(![fileManger createFolderAtPathIfNeeds:directory]) {
            return nil;
        }
        
        // eg. Documents/users/404298011/im
        // eg. Documents/users/404298011/addressbook
        if(module.length) {
            directory = [directory stringByAppendingPathComponent:module];
            if(![fileManger createFolderAtPathIfNeeds:directory]) {
                return nil;
            }
        }
    }
    return directory;
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

- (NSString *)directoryWithMask:(MMDirectoryMask)mask {
    return (mask == MMDirectoryMaskDocument ? mm_document_path() :
            mask == MMDirectoryMaskTemporary ? mm_temporary_path() :
            mask == MMDirectoryMaskCaches ? mm_caches_path() :
            mask == MMDirectoryMaskLibrary ? mm_library_path() :
            nil);
}

- (NSString *)filenameWithFileType:(MMDiskCacheFileType)type {
    return (type == MMDiskCacheFileTypeImage ? @"image" :
            type == MMDiskCacheFileTypeVideo ? @"video" :
            @"");
}

@end
