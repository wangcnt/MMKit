//
//  NSStringAdditions.h
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Additions)


- (NSString *)percentEscapedString;
- (instancetype)gb18030edStringWithData:(NSData *)data;
- (NSString *)md5edString;
- (NSString *)stringByDeletingEmoji;

- (NSString *)pinyin;
- (NSString *)firstletter;

- (NSArray *)componentsSeparatedByCharactersInString:(NSString *)chars;

- (NSString *)stringByTrimmingWhitespace;
- (NSString *)stringByTrimmingWhitespaceAndNewlines;
- (NSString *)stringByStrippingHTML;

- (NSString *)reversedString;

- (NSString *)text;   /// 转换成文本，防nil

+ (instancetype)stringWithBytes:(unsigned long long)bytes;
+ (NSString *)uuid;
- (NSString *)phoneNumber;

/**
 * No           -> 123456789
 * Decimal      -> 123,456,789
 * Currency     -> ￥123,456,789.00
 * Percent      -> -539,222,988%
 * Scientific   -> 1.23456789E8
 * SpellOut     -> 一亿二千三百四十五万六千七百八十九
 */
+ (NSString *)stringFromNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style;

- (void)enumerateIntegersUsingBlock:(void (^)(NSInteger integer, BOOL *stop))block;
- (void)enumerateNumbersUsingBlock:(void (^)(NSNumber *number, BOOL *stop))block;
- (void)enumerateSubstringsWithRegex:(NSString *)regex usingBlock:(void (^)(NSString *substring, NSRange range, BOOL *stop))block;
- (NSArray<NSNumber *> *)numbers;
- (NSArray<NSNumber *> *)integers;

+ (instancetype)stringWithTimeInterval:(NSTimeInterval)interval;
+ (instancetype)abbreviatedStringWithNumber:(NSInteger)number;

@end

@interface NSString (Validating)

- (BOOL)matchesRegex:(NSString *)regex;
- (BOOL)isEmpty;
- (BOOL)containsEmoji;
- (BOOL)isMobileNumberClassification;;
- (BOOL)isMobileNumber;
- (BOOL)isEmailAddress;
- (BOOL)isCarNumber;
- (BOOL)isMacAddress;
- (BOOL)isHTTPOrHTTPSUrl;
- (BOOL)containsChinese;
- (BOOL)isPostalCode;
- (BOOL)isTax;
- (BOOL)isIP;
- (BOOL)isSimpleIDCard;
- (BOOL)isAccurateIDCard;

@end

@interface NSString (Version)

- (BOOL)isGreaterThanVersion:(NSString *)version;
- (BOOL)isNotGreaterThanVersion:(NSString *)version;
- (BOOL)isSmallerThanVersion:(NSString *)version;
- (BOOL)isNotSmallerThanVersion:(NSString *)version;
- (BOOL)isEqualToVersion:(NSString *)version;
- (NSComparisonResult)compareVersion:(NSString *)version;

@end

@interface NSString (JSON)

- (id)JSONObject;

@end

@interface NSMutableString(Additions)

- (void)reverse;

- (NSUInteger)replaceOccurrencesOfString:(NSString *)source withString:(NSString *)replacement;

- (NSUInteger)deleteOccurrencesOfString:(NSString *)string;

//!!!:
- (void)deleteBeforeString:(NSString *)string;  ///< aaabaa:ba -> baa
- (void)deleteAfterString:(NSString *)string;  ///< aaabaa:ba -> aaaba
- (void)deleteFromString:(NSString *)string;  ///< aaabaa:ba -> aaa
- (void)deleteToString:(NSString *)string;  ///< aaabaa:ba -> a

//!!!:
- (void)remainAfterString:(NSString *)string;
- (void)remainBeforeString:(NSString *)string;
- (void)remainFromString:(NSString *)string;
- (void)remainToString:(NSString *)string;

/**
 *  remain adfasdfasdf
 */
- (void)remainCharactersToIndex:(NSUInteger)to;
- (void)deleteCharactersFromIndex:(NSUInteger)from;

@end

@interface NSMutableString (Networking)
- (void)appendQueryParamenters:(NSDictionary<NSString *, NSObject *> *)parameters;
@end
