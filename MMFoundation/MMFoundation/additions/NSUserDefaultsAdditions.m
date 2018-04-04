//
//  NSUserDefaultsAdditions.m
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "NSUserDefaultsAdditions.h"

#import "MMDefines.h"

__mm_synth_dummy_class__(NSUserDefaultsAdditions)

@implementation NSUserDefaults (Additions)

- (void)setValue:(id)value forKey:(NSString *)key toiCloud:(BOOL)iCloud {
    if (iCloud) {
        [[NSUbiquitousKeyValueStore defaultStore] setValue:value forKey:key];
    }
    
    [self setValue:value forKey:key];
}

- (id)valueForKey:(NSString *)key toiCloud:(BOOL)iCloud {
    if (iCloud) {
        //Get value from iCloud
        id value = [[NSUbiquitousKeyValueStore defaultStore] valueForKey:key];
        //Store locally and iCloudhronize
        [self setValue:value forKey:key];
        [self synchronize];
        return value;
    }
    return [self valueForKey:key];
}

- (void)removeValueForKey:(NSString *)key toiCloud:(BOOL)iCloud {
    [self removeObjectForKey:key toiCloud:iCloud];
}



- (void)setObject:(id)value forKey:(NSString *)key toiCloud:(BOOL)iCloud {
    if (iCloud) {
        [[NSUbiquitousKeyValueStore defaultStore] setObject:value forKey:key];
    }
    [self setObject:value forKey:key];
}

- (id)objectForKey:(NSString *)key toiCloud:(BOOL)iCloud {
    if (iCloud) {
        //Get value from iCloud
        id value = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
        //Store to NSUserDefault and iCloudhronize
        [self setObject:value forKey:key];
        [self synchronize];
        return value;
    }
    return [self objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key toiCloud:(BOOL)iCloud {
    if (iCloud) {
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:key];
    }
    //Remove from NSUserDefault
    return [self removeObjectForKey:key];
}

- (BOOL)synchronizeAlsoToiCloud:(BOOL)iCloud {
    BOOL res = YES;
    if (iCloud) {
        res &= [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
    res &= [self synchronize];
    return res;
}

@end
