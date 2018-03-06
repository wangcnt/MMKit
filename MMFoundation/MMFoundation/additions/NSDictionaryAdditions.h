//
//  NSDictionaryAdditions.h
//  QTCoreServices
//
//  Created by Mark on 15/7/27.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Additions)

- (NSMutableDictionary *)mutableDeepCopy;
- (NSObject *)objectForCDKey:(NSString *)key;   ///< Case-insensived objectForKey:

@end


@interface NSDictionary(JSON)

- (NSString *)JSONString;

@end
