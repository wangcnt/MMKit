//
//  MMSafeSignleton.m
//  MMSamples
//
//  Created by Mark on 2018/3/10.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMSafeSignleton.h"

#import <MMFoundation/MMDefines.h>

@implementation MMSafeSignleton

__singleton__(MMSafeSignleton)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"aaa";
    }
    return self;
}


@end
