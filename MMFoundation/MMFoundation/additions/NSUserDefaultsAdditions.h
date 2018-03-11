//
//  NSUserDefaultsAdditions.h
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Additions)

- (void)setValue:(id)value forKey:(NSString *)key toiCloud:(BOOL)iCloud;
- (id)valueForKey:(NSString *)key toiCloud:(BOOL)iCloud;
- (void)removeValueForKey:(NSString *)key toiCloud:(BOOL)iCloud;
- (void)setObject:(id)value forKey:(NSString *)key toiCloud:(BOOL)iCloud;
- (id)objectForKey:(NSString *)key toiCloud:(BOOL)iCloud;
- (void)removeObjectForKey:(NSString *)key toiCloud:(BOOL)iCloud;
- (BOOL)synchronizeAlsoToiCloud:(BOOL)iCloud;

@end
