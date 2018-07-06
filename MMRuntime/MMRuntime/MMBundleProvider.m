//
//  MMBundleProvider.m
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMBundleProvider.h"

@implementation MMBundleManager

- (MMBundle *)bundleDelegateForURI:(MMURI *)uri {
    return nil;
}

- (void)installBundleWithURI:(MMURI *)uri {
    
}

- (void)installEmbeddedBundles {
    
}

- (void)installDownloadedBundleWithURI:(MMURI *)uri completion:(void (^)(NSError *error))completion {
    
}

- (MMBundle *)bundleWithURI:(MMURI *)uri {
    return nil;
}

- (NSArray<MMBundle *> *)bundles {
    
}

- (BOOL)bundleIsInstalledForIdentifier:(MMURI *)uri {
    
}

- (void)analyticsUsageUsingProgress:(void (^)(MMBundle *bundle, unsigned long long totalSize, unsigned long long analyzedSize))progress withCompletion:(void (^)(MMBundle *bundle))completion {
    
}

- (void)clearBundleStorageWithURI:(MMURI *)uri {
    
}

@end
