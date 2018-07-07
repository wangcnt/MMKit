//
//  AKServiceCenter.m
//  AnalyticsKit
//
//  Created by Mark on 2018/3/18.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "AKServiceCenter.h"

#import <MMFoundation/MMDefines.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
#pragma clang diagnostic ignored "-Wobjc-protocol-property-synthesis"

@implementation AKServiceCenter

#pragma clang diagnostic pop

__proxy_singleton__(AKServiceCenter)

- (instancetype)init
{
    self = [super init];
    if (self) {
        AKService *service = [[AKService alloc] init];
        [self startService:service];
    }
    return self;
}

@end
