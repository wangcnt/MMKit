//
//  MMDiskCache.h
//  MMFoundation
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Account-based disk cache.
 *
 * [] : 目錄
 * <> : 文件
 *
 * [documents]
 *    [users]
 *        [user-1]
 *            [module-1]
 *                [video]
 *                [/video]
 *                [image]
 *                [/image]
 *            [/module-1]
 *            [module-2]
 *            [/module-2]
 *            ...
 *        [/user-1]
 *        [user-2]
 *            [module-2]
 *            [/module-2]
 *            ...
 *        [/user-2]
 *    [/users]
 *    [logs]
 *        ***1.log.archive.gz
 *        ***2.log.archive.gz
 *        ***.log
 *        ...
 *    [/logs]
 *    ...
 * [/documents]
 *
 * [Library]
 *    [users]
 *        [user-1]
 *            [module-1]
 *            [/module-1]
 *            ...
 *        [/user-1]
 *        [user-2]
 *            [module-2]
 *            [/module-2]
 *            ...
 *        [/user-2]
 *        ...
 *    [/users]
 *    ...
 * [/Library]
 *
 * [Caches]
 *
 * [/Caches]
 *
 * [tmp]
 * [/tmp]
 *
 */

typedef NS_ENUM(NSInteger, MMDirectoryMask) {
    MMDirectoryMaskUnknown,
    MMDirectoryMaskDocument,
    MMDirectoryMaskTemporary,
    MMDirectoryMaskLibrary,
    MMDirectoryMaskCaches
};

// unused
typedef NS_ENUM(NSInteger, MMDirectoryCategory) {
    MMDirectoryCategoryUnknown,
    MMDirectoryCategoryVideo,
    MMDirectoryCategoryImage,
    MMDirectoryCategoryAudio,
    MMDirectoryCategoryDatabase,
    MMDirectoryCategoryOther
};

@interface MMDiskCache : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong, readonly) NSString *documentsPath;
@property (nonatomic, strong, readonly) NSString *temporaryPath;
@property (nonatomic, strong, readonly) NSString *libraryPath;
@property (nonatomic, strong, readonly) NSString *cachesPath;

- (NSString *)directoryWithMask:(MMDirectoryMask)mask;

- (NSString *)directoryWithMask:(MMDirectoryMask)mask account:(NSString *)account;
- (NSString *)directoryWithMask:(MMDirectoryMask)mask account:(NSString *)account module:(NSString *)module; ///< module: MMServiceCenter.name
- (NSString *)directoryWithMask:(MMDirectoryMask)mask account:(NSString *)account module:(NSString *)module category:(NSString *)category;  // Format: mask/(users/account/module/)category, that means users, account and module will be ignored if either account or module is empty. Eg.: Documents/users/404298011/im/images, Documents/images.

@end

