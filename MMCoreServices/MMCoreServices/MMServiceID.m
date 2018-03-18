
//
//  MMServiceID.m
//  MMCoreServices
//
//  Created by Mark on 2018/3/18.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMServiceID.h"
#import <MMFoundation/NSStringAdditions.h>

@implementation MMServiceID

- (instancetype)init
{
    self = [super init];
    if (self) {
        _identifier = [NSString uuid];
    }
    return self;
}

- (NSString *)serviceKey {
    return _identifier;
}

@synthesize identifier = _identifier;
@synthesize serviceKey = _serviceKey;

@end
