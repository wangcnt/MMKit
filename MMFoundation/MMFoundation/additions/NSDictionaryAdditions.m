//
//  NSDictionaryAdditions.m
//  QTCoreServices
//
//  Created by Mark on 15/7/27.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "NSDictionaryAdditions.h"

#import "NSArrayAdditions.h"

@implementation NSDictionary(Additions)

- (NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for(int i=0; i<self.allKeys.count; i++) {
        NSString *key = self.allKeys[i];
        NSObject *o = self[key];
        if([o respondsToSelector:@selector(mutableDeepCopy)]) {
            id copied = [o performSelector:@selector(mutableDeepCopy)];
            result[key] = copied;
        } else if([o respondsToSelector:@selector(mutableCopyWithZone:)]) {
            id copied = [o mutableCopy];
            result[key] = copied;
        } else if([o respondsToSelector:@selector(copy)]) {
            id copied = [o copy];
            result[key] = copied;
        } else {
            result[key] = o;
        }
    }
    return result;
}

@end


@implementation NSDictionary(JSON)

- (NSString *)JSONString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) {
            return json;
        }
    }
    return nil;
}

@end
