//
//  NSDictionaryAdditions.h
//  QTCoreServices
//
//  Created by Mark on 15/7/27.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (BOOL)isEmpty;
- (NSMutableDictionary *)mutableDeepCopy;
- (NSObject *)objectForCDKey:(NSString *)key;   ///< Case-insensived objectForKey:

- (NSArray *)allKeysSorted;
- (NSArray *)allValuesSortedByKeys;
- (BOOL)containsObjectForKey:(id)key;
- (NSDictionary *)entriesForKeys:(NSArray *)keys;

@end

@interface NSDictionary (Plist)

+ (NSDictionary *)dictionaryWithPlistData:(NSData *)plist;
+ (NSDictionary *)dictionaryWithPlistString:(NSString *)plist;
- (NSData *)plistData;
- (NSString *)plistString;

@end


@interface NSDictionary (JSON)

- (NSString *)JSONString;

@end

@interface NSDictionary (XML)

+ (NSDictionary *)dictionaryWithXML:(id)xml;

@end

@interface NSMutableDictionary (Plist)

+ (NSMutableDictionary *)dictionaryWithPlistData:(NSData *)plist;
+ (NSMutableDictionary *)dictionaryWithPlistString:(NSString *)plist;

- (id)popObjectForKey:(id)aKey;
- (NSDictionary *)popEntriesForKeys:(NSArray *)keys;

@end
