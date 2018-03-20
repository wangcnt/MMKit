//
//  AKServiceCenter.m
//  AnalyticsKit
//
//  Created by Mark on 2018/3/18.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "AKServiceCenter.h"

#import <MMFoundation/MMDefines.h>

@implementation AKServiceCenter

__singleton__(AKServiceCenter)

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
