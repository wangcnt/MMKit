//
//  MMBundleProvider.h
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMBundle;
@protocol MMBundleDelegate;

@protocol MMBundleProvider

- (id<MMBundleDelegate>)bundleDelegateForIdentifier:(NSString *)identifier;

@end

@interface MMBundleManager : NSObject <MMBundleProvider>

+ (instancetype)sharedInstance;

- (BOOL)installBundleWithIdentifier:(NSString *)identifier frameworkName:(NSString *)frameworkName;
- (void)installEmbeddedBundles;
- (void)installDownloadedBundleWithIdentifier:(NSString *)identifier completion:(void (^)(NSError *error))completion;

- (MMBundle *)bundleWithIdentifier:(NSString *)identifier;

- (BOOL)bundleIsInstalledForIdentifier:(NSString *)identifier;

- (void)analyticsUsageUsingProgress:(void (^)(MMBundle *bundle, unsigned long long totalSize, unsigned long long analyzedSize))progress withCompletion:(void (^)(MMBundle *bundle))completion;
- (void)clearBundleStorageWithIdentifier:(NSString *)identifier;

@end
