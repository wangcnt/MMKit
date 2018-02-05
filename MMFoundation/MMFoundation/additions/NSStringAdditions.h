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
- (NSString *)gb18030edStringWithData:(NSData *)data;
- (NSString *)md5edString;

- (BOOL)containsEmoji;
- (NSString *)stringByDeletingEmoji;

- (NSString *)pinyin;
- (NSString *)firstletter;

- (NSString *)text;   /// 转换成文本，防nil

@end

@interface NSString (JSON)

- (id)JSONObject;

@end

@interface NSMutableString(Additions)

- (void)replaceOccurrencesOfString:(NSString *)source withString:(NSString *)replacement;

- (void)deleteOccurrencesOfString:(NSString *)string;

//!!!:
- (void)deleteBeforeString:(NSString *)string;
- (void)deleteAfterString:(NSString *)string;
- (void)deleteFromString:(NSString *)string;
- (void)deleteToString:(NSString *)string;

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
