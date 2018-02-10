//
//  MMDiskCache.h
//  MMFoundation
//
//  Created by WangQiang on 2018/2/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MMDiskCacheDirectoryType) {
    MMDiskCacheDirectoryTypeDocument,
    MMDiskCacheDirectoryTypeTemporary,
    MMDiskCacheDirectoryTypeLibrary,
    MMDiskCacheDirectoryTypeCache
};

typedef NS_ENUM(NSInteger, MMDiskCacheFileType) {
    MMDiskCacheFileTypeImage,
    MMDiskCacheFileTypeVideo,
    MMDiskCacheFileTypeDatabase,
    // 以上是目錄，以下是文件
    MMDiskCacheFileTypeLog
};

@interface MMDiskCache : NSObject

- (instancetype)sharedInstance;

@property (nonatomic, strong, readonly) NSString *documentsPath;
@property (nonatomic, strong, readonly) NSString *temporaryPath;
@property (nonatomic, strong, readonly) NSString *libraryPath;
@property (nonatomic, strong, readonly) NSString *cachesPath;

- (NSString *)logPath;  // Documents/app.log
- (NSString *)pathWithIdentifier:(NSString *)identifier directoryType:(MMDiskCacheDirectoryType)directoryType fileType:(MMDiskCacheFileType)fileType;

@end
