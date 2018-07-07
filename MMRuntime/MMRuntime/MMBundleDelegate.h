//
//  MMBundleDelegate.h
//  MMRuntime
//
//  Created by Mark on 2018/7/7.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMURI, MMBundle;

@protocol MMBundleDelegate

@required
- (id)resourceForURI:(MMURI *)uri;

@optional
- (void)bundleDidLoad;
- (void)bundleWillUnload;

- (void)bundleWillUninstall;

- (unsigned long long)bundleDataSize;
- (void)eraseBundleData;

- (void)bundle:(MMBundle *)bundle didReceiveRemoteNotification:(NSDictionary *)info;
- (void)bundle:(MMBundle *)bundle openURL:(NSURL *)url withSourceApp:(NSString *)source annotation:(id)annotation;

@end

@interface MMBundleDelegate : NSObject <MMBundleDelegate>

@end



