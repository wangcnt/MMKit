//
//  NSMutableDictionary+Database.h
//  MMime
//
//  Created by Mark on 15/6/10.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(Database)

/**
 *  去掉空值，不然组装sql语句容易出错，出现连续的,,
 *
 *  @param dic dic description
 */
- (void)nonnullify;

@end
