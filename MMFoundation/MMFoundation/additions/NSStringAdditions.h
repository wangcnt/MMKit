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

- (BOOL)containsEmoji;
- (NSString *)stringByDeletingEmoji;

- (NSString *)pinyin;
- (NSString *)firstletter;

- (NSString *)text;   /// 转换成文本，防nil

+ (instancetype)stringWithBytes:(unsigned long long)bytes;
+ (NSString *)uuid;
- (NSString *)phoneNumber;

- (NSArray<NSNumber *> *)numbers;

+ (instancetype)stringWithTimeInterval:(NSTimeInterval)interval;
+ (instancetype)abbreviatedStringWithNumber:(NSInteger)number;

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

- (void)replaceOccurrencesOfString:(NSString *)source withString:(NSString *)replacement;

- (void)deleteOccurrencesOfString:(NSString *)string;

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
