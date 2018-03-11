//
//  NSDateFormatterAdditions.h
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Additions)

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
+ (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)style;
+ (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone;
+ (NSDateFormatter *)dateFormatterWithTimeStyle:(NSDateFormatterStyle)style;
+ (NSDateFormatter *)dateFormatterWithTimeStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone;

@end
