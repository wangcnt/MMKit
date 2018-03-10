//
//  UIApplicationAdditions.m
//  MMUIKit
//
//  Created by Mark on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "UIApplicationAdditions.h"
#import <MMFoundation/MMFoundation.h>
#import "MMUIDefines.h"

@implementation UIApplication(Additions)

- (NSString *)applicationSize {
    unsigned long long docSize   =  [self folderSizeAtPath:[self documentPath]];
    unsigned long long libSize   =  [self folderSizeAtPath:[self libraryPath]];
    unsigned long long cacheSize =  [self folderSizeAtPath:[self cachePath]];
    unsigned long long total = docSize + libSize + cacheSize;
    NSString *totalSize = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    return totalSize;
}

- (NSString *)documentPath {
    return mm_document_path();
}

- (NSString *)libraryPath {
    return mm_library_path();
}

- (NSString *)cachePath {
    return mm_caches_path();
}

-(unsigned long long)folderSizeAtPath:(NSString *)folderPath {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    NSString *file;
    unsigned long long size = 0;
    NSString *path = @"";
    NSDictionary *fileAttributes = nil;
    while (file = [contentsEnumurator nextObject]) {
        path = [folderPath stringByAppendingPathComponent:file];
        fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        size += [fileAttributes[NSFileSize] longLongValue];
    }
    return size;
}

- (NSString *)applicationName {
    static NSString *appName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
        if (!appName) {
            appName = [[NSProcessInfo processInfo] processName];
        }
        if (!appName) {
            appName = @"";
        }
    });
    NSMutableArray *components = [NSMutableArray arrayWithArray:[appName componentsSeparatedByString:@"."]];
    [components filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF <> ''"]];
    return [components componentsJoinedByString:@"."];
}

- (UIViewController *)topViewControllerForController:(UIViewController *)controller {
    if (controller.presentedViewController) {
        return [self topViewControllerForController:controller.presentedViewController];
    } else if ([controller isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController*) controller;
        if (svc.viewControllers.count) {
            return [self topViewControllerForController:svc.viewControllers.lastObject];
        }
    } else if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *svc = (UINavigationController*) controller;
        if (svc.viewControllers.count) {
            return [self topViewControllerForController:svc.topViewController];
        }
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *svc = (UITabBarController *)controller;
        if (svc.viewControllers.count > 0) {
            return [self topViewControllerForController:svc.selectedViewController];
        }
    }
    return controller;
}

- (UIViewController *)currentViewController {
    UIViewController *controller = mm_main_window().rootViewController;
    return [self topViewControllerForController:controller];
}

- (UINavigationController *)currentNavigatonController {
    return [self currentViewController].navigationController;
}

- (BOOL)rate {
    NSString *identifier = mm_bundle_identifier();
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", identifier];
    return [self openURL:[NSURL URLWithString:urlString]];
}

@end
