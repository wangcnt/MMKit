//
//  MMChain.m
//  MMSamples
//
//  Created by Mark on 2018/3/25.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMChain.h"

#import <MMFoundation/MMDefines.h>

@interface MMChain ()
@property (nonatomic, strong) NSMutableArray *commands;
@end

@implementation MMChain


__singleton__(MMChain)

//- (MASConstraint * (^)(MASEdgeInsets))insets {
//    return ^id(MASEdgeInsets insets){
//        self.insets = insets;
//        return self;
//    };
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _commands = [NSMutableArray array];
    }
    return self;
}

- (MMChain * (^)(NSString *))addString {
    return ^ id (NSString *string) {
        if(string) {
            [_commands addObject:string];
        }
        return self;
    };
}

- (MMChain * (^)(int))addInteger {
    return ^ id (int intValue) {
        [_commands addObject:@(intValue)];
        return self;
    };
}

- (MMChain * (^)(void))print {
    return ^ id () {
        NSMutableString *result = [NSMutableString string];
        for(NSObject *obj in _commands) {
            [result appendFormat:@"%@", obj];
        }
        NSLog(@"%@", result);
        return self;
    };
}

- (NSString *)defaultValue {
    return @"I am the default value";
}


@end
