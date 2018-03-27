//
//  NSStringAdditions.h
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, NSStringMatchingOptions) {
    NSStringMatchingOptionNone = 1 << 0,
    NSStringMatchingOptionFavorSmallerWords = 1 << 1,
    NSStringMatchingOptionReducedLongStringPenalty = 1 << 2
};

@interface NSString(Additions)

- (NSString *)md5edString;

- (NSString *)pinyin;
- (NSString *)firstletter;

- (NSArray *)componentsSeparatedByCharactersInString:(NSString *)chars;

- (NSString *)stringByTrimmingWhitespace;
- (NSString *)stringByTrimmingWhitespaceAndNewlines;

- (NSString *)reversedString;

- (NSString *)text;   /// 转换成文本，防nil

+ (NSString *)uuid;
+ (NSString *)timestamp;
- (void)enumerateSubstringsWithRegex:(NSString *)regex usingBlock:(void (^)(NSString *substring, NSRange range, BOOL *stop))block;

@end

@interface NSString (Number)

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
- (NSArray<NSNumber *> *)numbers;
- (NSArray<NSNumber *> *)integers;

@end

@interface NSString (HumanizedFormat)

+ (NSString *)stringWithBytes:(unsigned long long)bytes;  ///< 12KB, 26.3MB, 576bytes
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)interval;  ///< 一年前，半年前，几月前，刚才，几小时前,  几分钟前，几天前，yyyy-MM-dd. Referenced by 1970.
+ (NSString *)abbreviatedStringWithNumber:(NSInteger)number;   ///< 324, 3k+, 3w+, 3kw+

@end

@interface NSString (Networking)

- (NSString *)percentEscapedString;
- (NSString *)queryParameters;
- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)parameters;
- (NSString *)stringByDeletingQueryParameters;
- (NSString *)stringByDeletingURLPrefix;
- (NSString *)stringByStrippingHTML;
- (NSString *)stringByDeletingScripts;
- (NSString *)stringByDeletingHTMLElements;
- (NSString *)stringByDeletingEmptyTitle;

@end

@interface NSString (Coding)

+ (NSString *)stringWithUnicodeString:(NSString *)unicodeString;
- (NSString *)gb18030edStringWithData:(NSData *)data;
- (NSString *)stringByDeletingEmoji;

@end

@interface NSString (MIME)

- (NSString *)MIMEType;
+ (NSString *)MIMETypeForExtension:(NSString *)extension;

@end

@interface NSString (MatchingScore)

- (float)scoreAgainst:(NSString *)otherString;
- (float)scoreAgainst:(NSString *)otherString fuzziness:(NSNumber *)fuzziness;
- (float)scoreAgainst:(NSString *)anotherString fuzziness:(NSNumber *)fuzziness options:(NSStringMatchingOptions)options;

@end

@interface NSString (Validating)

- (BOOL)matchesRegex:(NSString *)regex;
- (BOOL)isEmpty;
- (BOOL)containsWhitespace;
- (BOOL)containsChinese;
- (BOOL)containsEmoji;
- (BOOL)containsCharacterInString:(NSString *)inString;
- (BOOL)isMobileNumberClassification;
- (BOOL)isMobileNumber;
- (BOOL)isEmailAddress;
- (BOOL)isCarNumber;
- (BOOL)isMacAddress;
- (BOOL)isHTTPOrHTTPSUrl;
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
- (void)deleteHTMLElements; ///< Delete all html elements contains styles, titles, scripts, heads, & markups to pure text.
- (void)deleteEmptyTitle;   ///< Nothing will be displayed for WKWebView if title is empty.
@end
