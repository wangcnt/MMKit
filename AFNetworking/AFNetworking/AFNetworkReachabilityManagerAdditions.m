
//
//  AFNetworkReachabilityManagerAdditions.m
//  AFNetworking
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AFNetworkReachabilityManagerAdditions.h"

#import <CFNetwork/CFNetwork.h>

@implementation AFNetworkReachabilityManager (Additions)

- (BOOL)proxied {
    NSDictionary *proxySettings = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
    NSLog(@"%@", settings[(NSString *)kCFProxyHostNameKey]);
    NSLog(@"%@", settings[(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"%@", settings[(NSString *)kCFProxyTypeKey]);
    
    return ![[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"];
}

@end
