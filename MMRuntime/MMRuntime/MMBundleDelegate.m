//
//  MMBundleDelegate.m
//  MMRuntime
//
//  Created by Mark on 2018/7/7.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMBundleDelegate.h"

#import <MMLog/MMLog.h>
#import "MMURI.h"

@implementation MMBundleDelegate

- (id)resourceForURI:(MMURI *)uri {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", uri.action]);
    if([self respondsToSelector:selector]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:selector withObject:uri.parameters];
#pragma clang diagnostic pop
    }
    MMLogInfo(@"Resource %@ not reachable for target %@", NSStringFromSelector(selector), uri.target);
    return nil;
}

@end
