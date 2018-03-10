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

- (NSString *)directoryWithMask:(MMDirectoryMask)mask account:(NSString *)account {
    return [self directoryWithMask:mask account:account module:nil];
}

- (NSString *)directoryWithMask:(MMDirectoryMask)mask account:(NSString *)account module:(NSString *)module {
    return [self directoryWithMask:mask account:account module:module category:nil];
}

- (NSString *)directoryWithMask:(MMDirectoryMask)mask account:(NSString *)account module:(NSString *)module category:(NSString *)category {
    // eg. Documents/
    NSString *directory = [self directoryWithMask:mask];
    if(!directory.length) {
        return nil;
    }
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if(account.length && module.length) {
        // eg. Documents/users
        directory = [directory stringByAppendingPathComponent:@"users"];
        // eg. Documents/users/404298011
        directory = [directory stringByAppendingPathComponent:account];
        // eg. Documents/users/404298011/im
        // eg. Documents/users/404298011/addressbook
        directory = [directory stringByAppendingPathComponent:module];
        if(![fileManger createFolderAtPathIfNeeds:directory]) {
            return nil;
        }
    }
    
    if(category.length) {
        // eg. Documents/videos/
        // eg. Documents/users/404298011/addressbook/videos
        directory = [directory stringByAppendingPathComponent:category];
        if(![fileManger createFolderAtPathIfNeeds:directory]) {
            return nil;
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
    return (mask == MMDirectoryMaskDocument ? self.documentsPath :
            mask == MMDirectoryMaskTemporary ? self.temporaryPath :
            mask == MMDirectoryMaskCaches ? self.cachesPath :
            mask == MMDirectoryMaskLibrary ? self.libraryPath :
            nil);
}

@end
