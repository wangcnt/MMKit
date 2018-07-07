//
//  QTimeUIBundleDelegate.m
//  QTimeUI
//
//  Created by Mark on 2018/7/7.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTimeUIBundleDelegate.h"

#import <MMCoreServices/MMCoreServices.h>
#import <QTimeFoundation/QTimeFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@implementation QTimeUIBundleDelegate

- (void)bundleDidLoad {
    [[QTServiceCenter sharedInstance] startService];
}

- (id)resourceForURI:(MMURI *)uri {
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", uri.action]);
    if([self respondsToSelector:selector]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:selector withObject:uri.parameters];
#pragma clang diagnostic pop
    }
    return @{ @"error" : [NSError errorWithDomain:MMRuntimeErrorDomain code:MMRuntimeErrorCodeNotImplemented userInfo:@{NSLocalizedDescriptionKey : @"Resource not reachable."}]};
}

- (void)invite:(NSDictionary *)parameters {
    [[QTServiceCenter sharedInstance] inviteTheGirlWithName:parameters[@"name"] step:^(MMRequestStep step) {
        NSLog(@"%@", mm_default_step_name_with_step(step));
    } completion:^(NSError *error) {
        if(error) {
            NSLog(@"大吉大利，今晚吃鸡.");
        } else {
            NSLog(@"Shut up and go away!");
        }
    }];
}

@end

NS_ASSUME_NONNULL_END
