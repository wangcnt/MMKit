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

- (instancetype)gb18030edStringWithData:(NSData *)data {
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

- (NSArray *)componentsSeparatedByCharactersInString:(NSString *)chars {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:chars];
    return [self componentsSeparatedByCharactersInSet:characterSet];
}

- (NSString *)stringByTrimmingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingWhitespaceAndNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)reversedString {
    NSMutableString *result = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [result appendString:substring];
    }];
    return result;
}

- (BOOL)matchesRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (NSString *)text {
    return ([self isKindOfClass:[NSString class]] && self.length)?self:@"";
}

+ (instancetype)stringWithBytes:(unsigned long long)bytes {
    static const void *magnitudes[] = {@"bytes", @"KB", @"MB", @"GB"};
    // Determine what magnitude the number of bytes is by shifting off 10 bits at a time
    // (equivalent to dividing by 1024).
    unsigned long magnitude = 0;
    unsigned long long highbits = bytes;
    unsigned long long inverseBits = ~((unsigned long long)0x3FF);
    while ((highbits & inverseBits)
           && magnitude + 1 < (sizeof(magnitudes) / sizeof(void *))) {
        // Shift off an order of magnitude.
        highbits >>= 10;
        magnitude++;
    }
    
    if (magnitude) {
        unsigned long long dividend = 1024 << (magnitude - 1) *10;
        double result = ((double)bytes / (double)(dividend));
        return [NSString stringWithFormat:@"%.2f %@", result, magnitudes[magnitude]];
    } else {
        // We don't need to bother with dividing bytes.
        return [NSString stringWithFormat:@"%lld %@", bytes, magnitudes[magnitude]];
    }
}

+ (NSString *)uuid {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *result = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    return result;
}

- (NSString *)phoneNumber {
    NSMutableString *result = [[NSMutableString alloc] init];
    [self enumerateIntegersUsingBlock:^(NSInteger integer, BOOL *stop) {
        [result appendFormat:@"%ld", integer];
    }];
    return result.length ? result : self;
}

+ (NSString *)stringFromNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = style;
    return [formatter stringFromNumber:number];
}

+ (instancetype)stringWithTimeInterval:(NSTimeInterval)interval {
    NSTimeInterval dif = [[NSDate date] timeIntervalSince1970] - interval;
    
    float difMinute = dif / 60.0;
    if (difMinute < 10) {
        return @"刚刚";
    }
    
    if (difMinute < 60) {
        return [NSString stringWithFormat:@"%.0f分钟前", difMinute];
    }
    
    float difHour = dif / 3600.0;
    if (difHour < 24) {
        return [NSString stringWithFormat:@"%.0f小时前", difHour];
    }
    
    float difDay = difHour / 24.0;
    if (difDay < 30) {
        return [NSString stringWithFormat:@"%.0f天前", difDay];
    }
    
    float difMonth = difDay / 30.0;
    if(difMonth < 6) {
        return [NSString stringWithFormat:@"%.0f月以前", floor(difMonth)];
    } else if (difMonth >= 6 && difMonth < 12) {
        return @"半年前";
    }
    
    float difYear = difMonth / 12.0;
    if (difYear >= 1 && difYear <= 2)  {
        return [NSString stringWithFormat:@"%.0f年以前", floor(difYear)];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
}

+ (NSString *)abbreviatedStringWithNumber:(NSInteger)number {
    int length = 1;
    NSInteger temp = number;
    while (temp / 10 > 0) {
        length ++;
        temp /= 10;
    }
    NSString *result = [NSString stringWithFormat:@"%ld", (long)number];
    if(length == 4) {
        long rest = (long)number % 1000;
        result = [NSString stringWithFormat:@"%ldk%@", (long)number / 1000, rest ? @"+" : @""];
    } else if(length >=5 && length < 8) {
        long rest = (long)number % 10000;
        result = [NSString stringWithFormat:@"%ldw%@", (long)number / 10000, rest ? @"+" : @""];
    } else if(length >= 8) {
        long rest = (long)number % (1000 *10000);
        result = [NSString stringWithFormat:@"%ldkw%@", (long)number / 1000 / 10000, rest ? @"+" : @""];
    }
    return result;
}

- (void)enumerateIntegersUsingBlock:(void (^)(NSInteger integer, BOOL *stop))block {
    [self enumerateSubstringsWithRegex:@"\\d+" usingBlock:^(NSString *substring, NSRange range, BOOL *stop) {
        if(block) {
            block(substring.integerValue, stop);
        }
    }];
}

- (void)enumerateNumbersUsingBlock:(void (^)(NSNumber *number, BOOL *stop))block {
    [self enumerateSubstringsWithRegex:@"\\d+(.\\d+)?" usingBlock:^(NSString *substring, NSRange range, BOOL *stop) {
        if(block) {
            block(@([substring rangeOfString:@"."].length ? substring.doubleValue : substring.integerValue), stop);
        }
    }];
}

- (void)enumerateSubstringsWithRegex:(NSString *)regex usingBlock:(void (^)(NSString *substring, NSRange range, BOOL *gameover))block {
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
    [expression enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        if(block) {
            block([self substringWithRange:match.range], match.range, stop);
        }
    }];
}

- (NSArray<NSNumber *> *)integers {
    NSMutableArray<NSNumber *> *integers = [NSMutableArray<NSNumber *> array];
    [self enumerateIntegersUsingBlock:^(NSInteger integer, BOOL *stop) {
        [integers addObject:@(integer)];
    }];
    return integers;
}

- (NSArray<NSNumber *> *)numbers {
    NSMutableArray<NSNumber *> *numbers = [NSMutableArray<NSNumber *> array];
    [self enumerateNumbersUsingBlock:^(NSNumber *number, BOOL *stop) {
        [numbers addObject:number];
    }];
    return numbers;
}

@end

@implementation NSString (Validating)

- (BOOL)isEmpty {
    return [self isKindOfClass:NSNull.class] || !self.length;
}

- (BOOL)containsEmoji {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return range.length;
}

//手机号分服务商
- (BOOL)isMobileNumberClassification {
    /**
     *手机号码
     *移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     *联通：130,131,132,152,155,156,185,186,1709
     *电信：133,1349,153,180,189,1700,173
     */
    //    NSString *MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         *中国移动：China Mobile
     11         *134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         *中国联通：China Unicom
     16         *130,131,132,152,155,156,185,186,1709
     17         */
    NSString *CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         *中国电信：China Telecom
     21         *133,1349,153,180,189,1700,173
     22         */
    NSString *CT = @"^1((33|53|73|8[09])\\d|349|700)\\d{7}$";
    
    
    /**
     25         *大陆地区固话及小灵通
     26         *区号：010,020,021,022,023,024,025,027,028,029
     27         *号码：七位或八位
     28         */
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    if (([self matchesRegex:CM])
        || ([self matchesRegex:CU])
        || ([self matchesRegex:CT])
        || ([self matchesRegex:PHS])) {
        return YES;
    }
    return NO;
}

//手机号有效性
- (BOOL)isMobileNumber {
    NSString *mobileRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    BOOL ret1 = [self matchesRegex:mobileRegex];
    return ret1;
}

//邮箱
- (BOOL)isEmailAddress {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self matchesRegex:emailRegex];
}

//身份证号
- (BOOL)isSimpleIDCard {
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self matchesRegex:regex2];
}

//车牌
- (BOOL)isCarNumber {
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    NSString *carRegex = @"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$";//其中\u4e00-\u9fa5表示unicode编码中汉字已编码部分，\u9fa5-\u9fff是保留部分，将来可能会添加
    return [self matchesRegex:carRegex];
}

- (BOOL)isMacAddress {
    NSString *macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    return  [self matchesRegex:macAddRegex];
}

- (BOOL)isHTTPOrHTTPSUrl {
    return [self matchesRegex:@"^((http)|(https))+:[^\\s]+\\.[^\\s]*$"];
}

- (BOOL)containsChinese {
    return [self matchesRegex:@"^[\u4e00-\u9fa5]+$"];
}

- (BOOL)isPostalCode {
    return [self matchesRegex:@"^[0-8]\\d{5}(?!\\d)$"];
}

- (BOOL)isTax {
    return [self matchesRegex:@"[0-9]\\d{13}([0-9]|X)$"];
}

- (BOOL)isIP {
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL matches = [pre evaluateWithObject:self];
    if (matches) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}

- (BOOL)isAccurateIDCard {
    NSString *value = [self stringByTrimmingWhitespaceAndNewlines];
    if (!value) {
        return NO;
    }
    int length = (int)value.length;
    if (length !=15 && length !=18) {
        return NO;
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *expression;
    NSUInteger numberOfMatches;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                expression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                  options:NSRegularExpressionCaseInsensitive
                                                                    error:nil];//测试出生日期的合法性
            } else {
                expression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                   error:nil];//测试出生日期的合法性
            }
            numberOfMatches = [expression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            return numberOfMatches;
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                expression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                  options:NSRegularExpressionCaseInsensitive
                                                                    error:nil];//测试出生日期的合法性
            } else {
                expression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                  options:NSRegularExpressionCaseInsensitive
                                                                    error:nil];//测试出生日期的合法性
            }
            numberOfMatches = [expression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberOfMatches) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                NSString *test = [value substringWithRange:NSMakeRange(17,1)];
                // 检测ID的校验位
                return [[M lowercaseString] isEqualToString:[test lowercaseString]];
            }
        default:
            return NO;
    }
}

@end


@implementation NSString (Version)

- (BOOL)isGreaterThanVersion:(NSString *)version {
    return [self compareVersion:version] == NSOrderedAscending;
}

- (BOOL)isNotGreaterThanVersion:(NSString *)version {
    return ![self isGreaterThanVersion:version];
}

- (BOOL)isSmallerThanVersion:(NSString *)version {
    return [self compareVersion:version] == NSOrderedDescending;
}

- (BOOL)isNotSmallerThanVersion:(NSString *)version {
    return ![self isSmallerThanVersion:version];
}

- (BOOL)isEqualToVersion:(NSString *)version {
    return [self compareVersion:version] == NSOrderedSame;
}

- (NSComparisonResult)compareVersion:(NSString *)version {
    NSArray<NSNumber *> *numbers1 = self.integers;
    NSArray<NSNumber *> *numbers2 = version.integers;
    if(numbers1.count && !numbers2.count)  return NSOrderedAscending;
    if(!numbers1.count && numbers2.count)  return NSOrderedDescending;
    
    __block NSComparisonResult result = NSOrderedSame;
    __block NSNumber *version2 = nil;
    [numbers1 enumerateObjectsUsingBlock:^(NSNumber *version1, NSUInteger idx, BOOL *stop) {
        // 最後一個元素時，第一个版本比第二个版本元素多，則大於
        if(idx == numbers2.count) {
            result = NSOrderedAscending;
            *stop = YES;
        } else {
            version2 = numbers2[idx];
            int v1 = version1.intValue;
            int v2 = version2.intValue;
            if(v1 > v2) {
                result = NSOrderedAscending;
                *stop = YES;
            } else if(v1 < v2) {
                result = NSOrderedDescending;
                *stop = YES;
            } else if(idx+1==numbers1.count && idx+1<numbers2.count) {
                // 第二个版本比第一个版本數字元素多
                result = NSOrderedDescending;
                *stop = YES;
            }
        }
    }];
    return result;
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

- (void)reverse {
    NSMutableString *temp = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [temp appendString:substring];
                          }];
    [self replaceCharactersInRange:NSMakeRange(0, self.length) withString:temp];
}

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
    if(range.length) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wformat"
        NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=0,length=%zd}", range.length+range.location];
#pragma clang diagnostic pop
        [self deleteCharactersInRange:NSRangeFromString(rangeString)];
    }
}

- (void)remainBeforeString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    if(range.length) {
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
    if(range.length) {
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

@implementation NSMutableString (Networking)

- (void)appendQueryParamenters:(NSDictionary<NSString *, NSObject *> *)parameters {
    if(!parameters.count) {
        return;
    }
    if(![self rangeOfString:@"?"].length) {
        [self appendString:@"?"];
    }
    NSString *key = nil, *value = nil;
    NSArray *keys = parameters.allKeys;
    BOOL shouldAnd = NO;
    for(int i=0; i<keys.count; i++) {
        key = keys[i];
        value = [parameters[key] description];
        value = [value percentEscapedString];
        if(!shouldAnd) {
            shouldAnd = [self rangeOfString:@"="].length;
        }
        [self appendFormat:@"%@%@=%@",  shouldAnd ? @"&" : @"", key, value];
    }
}

@end

