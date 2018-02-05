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

@end


@interface NSDictionary(JSON)

- (NSString *)JSONString;

@end
