//
//  MMBundleProvider.h
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMURI, MMBundle;

@protocol MMBundleProvider

- (MMBundle *)bundleDelegateForURI:(MMURI *)uri;

@end

@interface MMBundleManager : NSObject <MMBundleProvider>

- (void)installBundleWithURI:(MMURI *)uri;
- (void)installEmbeddedBundles;
- (void)installDownloadedBundleWithURI:(MMURI *)uri completion:(void (^)(NSError *error))completion;

- (MMBundle *)bundleWithURI:(MMURI *)uri;
- (NSArray<MMBundle *> *)bundles;

- (BOOL)bundleIsInstalledForIdentifier:(MMURI *)uri;

- (void)analyticsUsageUsingProgress:(void (^)(MMBundle *bundle, unsigned long long totalSize, unsigned long long analyzedSize))progress withCompletion:(void (^)(MMBundle *bundle))completion;
- (void)clearBundleStorageWithURI:(MMURI *)uri;

@end
