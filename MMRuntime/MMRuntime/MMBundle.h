//
//  MMBundle.h
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MMBundleStatus) {
    MMBundleStatusUnknown,
    MMBundleStatusDownloading,
    MMBundleStatusDownloaded,
    MMBundleStatusInstalling,
    MMBundleStatusInstalled,
    MMBundleStatusUninstalling,
    MMBundleStatusUninstalled
};

typedef NS_ENUM(NSInteger, MMBundleType) {
    MMBundleTypeStatic,
    MMBundleTypeDynamic
};

typedef NS_ENUM(NSInteger, MMBundleSubtype) {
    MMBundleSubtypeNone,
    MMBundleSubtypeUI,
    MMBundleSubtypeData,
    MMBundleSubtypeReactNative
};

@class MMURI;
@protocol MMBundleDelegate;

@interface MMBundle : NSObject

@property (nonatomic, strong) id<MMBundleDelegate> principalDelegate;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, assign) BOOL isEmbedded;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *frameworkName;
@property (nonatomic, assign) MMBundleStatus status;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, assign) NSTimeInterval lastAccessTimestamp;   ///< since 1970
@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, assign) MMBundleType type;
@property (nonatomic, assign) MMBundleSubtype subtype;

@end
