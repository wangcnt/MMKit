//
//  NSStringAdditions.m
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "NSStringAdditions.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Additions)

- (NSString *)gb18030edStringWithData:(NSData *)data {
    unsigned long encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:data encoding:encoding];
}

- (NSString *)percentEscapedString {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
//    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
//                                                                     NULL,
//                                                                     (CFStringRef)self,
//                                                                     NULL,
//                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                     kCFStringEncodingUTF8));
}

- (NSString *)md5edString {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString  stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
}

- (NSString *)stringByDeletingEmoji {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSString *result = [regex stringByReplacingMatchesInString:self
                                                       options:0
                                                         range:NSMakeRange(0, self.length)
                                                  withTemplate:@""];
    return result;
}

- (BOOL)containsEmoji {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return range.length;
}

- (NSString *)pinyin {
    if(!self.length)   return @"";
    CFMutableStringRef result = CFStringCreateMutableCopy(NULL, 0, (CFStringRef)self);
    CFStringTransform(result, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(result, NULL, kCFStringTransformStripDiacritics, NO);
    return (__bridge NSString *)result;
}

- (NSString *)firstletter {
    NSString *pinyin = self.pinyin;
    if(!pinyin.length) {
        return @"";
    }
    return [pinyin substringToIndex:1].uppercaseString;
}

- (NSString *)text {
    return ([self isKindOfClass:[NSString class]] && self.length)?self:@"";
}

@end

@implementation NSString (JSON)

- (id)JSONObject {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error)   {
        result = nil;
    }
    return result;
}

@end


@implementation NSMutableString(Additions)

- (void)replaceOccurrencesOfString:(NSString *)source withString:(NSString *)replacement {
    [self replaceOccurrencesOfString:source withString:replacement options:0 range:NSMakeRange(0, self.length)];
}

- (void)deleteOccurrencesOfString:(NSString *)string {
    [self replaceOccurrencesOfString:string withString:@""];
}

- (void)deleteBeforeString:(NSString *)string {
    [self remainFromString:string];
}

- (void)deleteToString:(NSString *)string {
    [self remainAfterString:string];
}

- (void)deleteAfterString:(NSString *)string {
    [self remainToString:string];
}

- (void)deleteFromString:(NSString *)string {
    [self remainBeforeString:string];
}

- (void)remainAfterString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    if(range.length == string.length) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wformat"
        NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=0,length=%zd}", range.length+range.location];
#pragma clang diagnostic pop
        [self deleteCharactersInRange:NSRangeFromString(rangeString)];
    }
}

- (void)remainBeforeString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    if(range.length == string.length) {
        [self deleteCharactersFromIndex:range.location];
    }
}

- (void)remainFromString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    if(range.length == string.length) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wformat"
        NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=0,length=%ld}", range.location];
#pragma clang diagnostic pop
        [self deleteCharactersInRange:NSRangeFromString(rangeString)];
    }
}

- (void)remainToString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    if(range.length == string.length) {
        [self deleteCharactersFromIndex:range.location+range.length];
    }
}

- (void)remainCharactersToIndex:(NSUInteger)to {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wformat"
    if(to<=self.length-1) {
        NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=0,length=%ld}", to+1];
        [self replaceCharactersInRange:NSRangeFromString(rangeString) withString:@""];
    } else {
        NSLog(@"[NSMutableString(Replacing...) remainCharactersToIndex:%ld]超范围截取[0...%ld]！", to, self.length);
    }
#pragma clang diagnostic pop
}

- (void)deleteCharactersFromIndex:(NSUInteger)from {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wformat"
    if(from<=self.length-1) {
        NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=%ld,length=%ld}",
                                 from,
                                 self.length-from];
        [self deleteCharactersInRange:NSRangeFromString(rangeString)];
    } else {
        NSLog(@"[NSMutableString(Replacing...) deleteCharactersFromIndex:%ld]超范围截取[0...%ld]！", from, self.length);
    }
#pragma clang diagnostic pop
}

@end
