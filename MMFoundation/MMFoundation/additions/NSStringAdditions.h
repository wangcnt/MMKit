//
//  NSStringAdditions.h
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, NSStringMatchingOptions) {
    NSStringMatchingOptionNone = 1 << 0,
    NSStringMatchingOptionFavorSmallerWords = 1 << 1,
    NSStringMatchingOptionReducedLongStringPenalty = 1 << 2
};

@interface NSString(Additions)

- (NSString *_Nullable)md5edString;

- (NSString *_Nullable)pinyin;
- (NSString *)firstletter;

- (NSArray *)componentsSeparatedByCharactersInString:(NSString *)chars;

- (NSString *)stringByTrimmingWhitespace;
- (NSString *)stringByTrimmingWhitespaceAndNewlines;

- (NSString *)reversedString;

- (NSString *)text;   /// 转换成文本，防nil

+ (NSString *)uuid;
+ (NSString *)timestamp;
- (void)enumerateSubstringsWithRegex:(NSString *)regex usingBlock:(void (^)(NSString *substring, NSRange range, BOOL *stop))block;
- (void)enumerateSubstringsWithRegex:(NSString *)regex expressionOptions:(NSRegularExpressionOptions)options usingBlock:(void (^)(NSString *substring, NSRange range, BOOL *stop))block;
- (void)enumerateSubstringsWithRegex:(NSString *)regex matchingOptions:(NSMatchingOptions)options usingBlock:(void (^)(NSString *substring, NSRange range, BOOL *stop))block;
- (void)enumerateSubstringsWithRegex:(NSString *)regex expressionOptions:(NSRegularExpressionOptions)expressionOptions matchingOptions:(NSMatchingOptions)matchingOptions usingBlock:(void (^)(NSString *substring, NSRange range, BOOL *gameover))block;

- (NSString *)stringByAppendingNameScale:(float)scale;
- (NSString *)stringByAppendingPathScale:(float)scale;

/**
 Return the path scale.
 
 e.g.
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
- (float)pathScale;

@end

@interface NSString (Security)

/**
 Returns a lowercase NSString for md2 hash.
 */
- (nullable NSString *)md2String;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (nullable NSString *)md4String;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (nullable NSString *)md5String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (nullable NSString *)sha1String;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (nullable NSString *)sha224String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (nullable NSString *)sha256String;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (nullable NSString *)sha384String;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (nullable NSString *)sha512String;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key The hmac key.
 */
- (nullable NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (nullable NSString *)crc32String;

@end

@interface NSString (Number)

- (NSNumber *)numberValue;
- (char)charValue;
- (unsigned char)unsignedCharValue;
- (short)shortValue;
- (unsigned short)unsignedShortValue;
- (unsigned int)unsignedIntValue;
- (long)longValue;
- (unsigned long)unsignedLongValue;
- (unsigned long long)unsignedLongLongValue;
- (NSUInteger)unsignedIntegerValue;

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

- (NSString *)stringByURLEncoding;
- (NSString *)stringByURLDecoding;
- (NSString *)queryParameters;
- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)parameters;
- (NSString *)stringByDeletingQueryParameters;
- (NSString *)stringByDeletingURLPrefix;
- (NSString *)stringByStrippingHTML;
- (NSString *)stringByEscapingHTML;
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

NS_ASSUME_NONNULL_END
