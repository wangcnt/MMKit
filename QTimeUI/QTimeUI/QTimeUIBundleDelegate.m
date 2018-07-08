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
#import "QTHomepageViewController.h"
#import <MMLog/MMLog.h>

NS_ASSUME_NONNULL_BEGIN

@implementation QTimeUIBundleDelegate

- (void)bundleDidLoad {
    [[QTServiceCenter sharedInstance] startService];
}

- (id)resourceForURI:(MMURI *)uri {
    return [super resourceForURI:uri];
}

- (void)invite:(NSDictionary *)parameters {
    [[QTServiceCenter sharedInstance] inviteTheGirlWithName:parameters[@"name"] step:^(MMRequestStep step) {
        void (^stepHanlder)(NSString *) = parameters[@"step"];
        if(stepHanlder) {
            stepHanlder(mm_default_step_name_with_step(step));
        }
    } completion:parameters[@"completion"]];
}

- (UIViewController *)main:(NSDictionary *)parameters {
    QTHomepageViewController *controller = [[QTHomepageViewController alloc] init];
    return controller;
}

@end

NS_ASSUME_NONNULL_END
