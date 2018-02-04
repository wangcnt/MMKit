//
//  NSMutableDictionary+Database.m
//  MMime
//
//  Created by Mark on 15/6/10.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "NSMutableDictionary+Database.h"

@implementation NSMutableDictionary(Database)

- (void)nonnullify
{
    [[self allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        
        id value = self[key];
        
        if([value isKindOfClass:[NSNull class]])
        {
            [self removeObjectForKey:key];
        }
    }];
}

@end
