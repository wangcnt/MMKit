//
//  MMBundleProvider.m
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMBundleProvider.h"

#import <MMFoundation/MMDefines.h>
#import "MMBundleDelegate.h"
#import "MMURI.h"
#import "MMBundle.h"

@interface MMBundleManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, MMBundle *> *bundles; ///< 注册成功的bundle
@end

@implementation MMBundleManager

__singleton__(MMBundleManager)

- (instancetype)init {
    self = [super init];
    if (self) {
        _bundles = [NSMutableDictionary<NSString *, MMBundle *> dictionary];
    }
    return self;
}

- (id<MMBundleDelegate>)bundleDelegateForIdentifier:(NSString *)identifier {
    return _bundles[identifier].principalDelegate;
}

- (BOOL)installBundleWithIdentifier:(NSString *)identifier frameworkName:(NSString *)frameworkName {
    BOOL successed = NO;
    if(identifier.length && frameworkName.length) {
        NSString *principalClassString = [NSString stringWithFormat:@"%@BundleDelegate", frameworkName];
        Class clazz = NSClassFromString(principalClassString);
        if(clazz) {
            id<MMBundleDelegate> bundleDelegate = [[clazz alloc] init];
            if(bundleDelegate) {
                MMBundle *bundle = [[MMBundle alloc] init];
                bundle.identifier = identifier;
                bundle.frameworkName = frameworkName;
                bundle.principalDelegate = bundleDelegate;
                _bundles[identifier] = bundle;
                successed = YES;
            }
        }
    }
    if(!successed) {
        NSLog(@"Framework %@ with identifier %@ install failed.", frameworkName, identifier);
    }
    return successed;
}

- (void)installEmbeddedBundles {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"plist"];
    NSDictionary *configuration = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *identifier = nil;
    NSString *frameworkName = nil;
    for(NSDictionary *item in configuration.allValues) {
        identifier = item[@"identifier"];
        frameworkName = item[@"frameworkName"];
        [self installBundleWithIdentifier:identifier frameworkName:frameworkName];
    }
}

- (void)installDownloadedBundleWithIdentifier:(NSString *)identifier completion:(void (^)(NSError *))completion {
    
}

- (MMBundle *)bundleWithIdentifier:(NSString *)identifier {
    return _bundles[identifier];
}

- (NSArray<MMBundle *> *)bundles {
    return _bundles.allValues;
}

- (BOOL)bundleIsInstalledForIdentifier:(NSString *)identifier {
    return _bundles[identifier] != nil;
}

- (void)analyticsUsageUsingProgress:(void (^)(MMBundle *bundle, unsigned long long totalSize, unsigned long long analyzedSize))progress withCompletion:(void (^)(MMBundle *bundle))completion {
    
}

- (void)clearBundleStorageWithIdentifier:(NSString *)identifier {
    
}

@end
