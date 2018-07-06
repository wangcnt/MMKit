//
//  MMBundle.m
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMBundle.h"

@implementation MMBundle

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = MMBundleTypeStatic;
        _bundle = [NSBundle mainBundle];
    }
    return self;
}

- (void)setBundle:(NSBundle *)bundle {
    if(_bundle != bundle) {
        _bundle = bundle;
        if(_bundle == [NSBundle mainBundle]) {
            _type = MMBundleTypeStatic;
        }
    }
}

- (void)setType:(MMBundleType)type {
    if(_type != type) {
        _type = type;
        if(_type == MMBundleTypeStatic) {
            _bundle = [NSBundle mainBundle];
        }
    }
}

@end
