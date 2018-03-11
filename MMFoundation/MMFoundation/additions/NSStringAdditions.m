//
//  NSStringAdditions.m
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "NSStringAdditions.h"
#import "NSDictionaryAdditions.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Additions)

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

- (NSString *)stringByDeletingScripts {
    NSMutableString *result = [self mutableCopy];
    NSError *error;
    NSString *pattern = @"<script[^>]*>[\\w\\W]*</script>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:result options:NSMatchingReportProgress range:NSMakeRange(0, [result length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [result replaceCharactersInRange:match.range withString:@""];
    }
    return result;
}

- (NSString *)reversedString {
    NSMutableString *result = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [result appendString:substring];
    }];
    return result;
}

- (NSString *)text {
    return ([self isKindOfClass:[NSString class]] && self.length)?self:@"";
}

+ (NSString *)uuid {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *result = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    return result;
}

+ (NSString *)timestamp {
    return @([[NSDate date] timeIntervalSince1970]*1000).stringValue;
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

@implementation NSString (HumanizedFormat)

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

@end

@implementation NSString (Networking)

- (NSString *)percentEscapedString {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
}

- (NSDictionary *)queryParameters {
    NSMutableDictionary *mute = @{}.mutableCopy;
    NSArray *paramaterArray = [[self stringByDeletingURLPrefix] componentsSeparatedByString:@"&"];
    for (NSString *query in paramaterArray) {
        NSArray *components = [query componentsSeparatedByString:@"="];
        if (components.count == 0) {
            continue;
        }
        NSString *key = [components[0] stringByRemovingPercentEncoding];
        id value = nil;
        if (components.count == 1) {
            // key with no value
            value = [NSNull null];
        }
        if (components.count == 2) {
            value = [components[1] stringByRemovingPercentEncoding];
            // cover case where there is a separator, but no actual value
            value = [value length] ? value : [NSNull null];
        }
        if (components.count > 2) {
            // invalid - ignore this pair. is this best, though?
            continue;
        }
        mute[key] = value ?: [NSNull null];
    }
    return mute.count ? mute.copy : nil;
}

- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)parameters {
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@", self];
    [result appendQueryParamenters:parameters];
    return result;
}

- (NSString *)stringByDeletingQueryParameters {
    NSArray *components = [self componentsSeparatedByString:@"?"];
    if (components.count) {
        return components.firstObject;
    }
    return self;
}

- (NSString *)stringByDeletingURLPrefix {
    NSArray *components = [self componentsSeparatedByString:@"?"];
    NSString *result = components.lastObject;
    return [result rangeOfString:@"="].length ? result : nil;
}

@end

@implementation NSString (Coding)

+ (NSString *)stringWithUnicodeString:(NSString *)unicodeString {
    NSString *tempStr1 = [unicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    //NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    
    NSString *result = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return [result stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSString *)gb18030edStringWithData:(NSData *)data {
    unsigned long encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:data encoding:encoding];
}

- (NSString *)stringByDeletingEmoji {
    NSString *regex = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    return [expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
}

@end

@implementation NSString (MIME)

- (NSString *)MIMEType {
    return [self.class MIMETypeForExtension:self.pathExtension];
}

+ (NSString *)MIMETypeForExtension:(NSString *)extension {
    return [self MIMEDictionary][extension.lowercaseString];
}

/**
 *  @brief  常见MIME集合
 *
 *  @return 常见MIME集合
 */
+ (NSDictionary *)MIMEDictionary {
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // ???: Should I have these return an array of MIME types? The first element would be the preferred MIME type.
        
        // ???: Should I have a couple methods that return the MIME media type name and the MIME subtype name?
        
        // Values from http://www.w3schools.com/media/media_mimeref.asp
        // There are probably values missed, but this is a good start.
        // A few more have been added that weren't included on the original list.
        dict = @{ @"":        @"application/octet-stream",
                  @"323":     @"text/h323",
                  @"acx":     @"application/internet-property-stream",
                  @"ai":      @"application/postscript",
                  @"aif":     @"audio/x-aiff",
                  @"aifc":    @"audio/x-aiff",
                  @"aiff":    @"audio/x-aiff",
                  @"asf":     @"video/x-ms-asf",
                  @"asr":     @"video/x-ms-asf",
                  @"asx":     @"video/x-ms-asf",
                  @"au":      @"audio/basic",
                  @"avi":     @"video/x-msvideo",
                  @"axs":     @"application/olescript",
                  @"bas":     @"text/plain",
                  @"bcpio":   @"application/x-bcpio",
                  @"bin":     @"application/octet-stream",
                  @"bmp":     @"image/bmp",
                  @"c":       @"text/plain",
                  @"cat":     @"application/vnd.ms-pkiseccat",
                  @"cdf":     @"application/x-cdf",
                  @"cer":     @"application/x-x509-ca-cert",
                  @"class":   @"application/octet-stream",
                  @"clp":     @"application/x-msclip",
                  @"cmx":     @"image/x-cmx",
                  @"cod":     @"image/cis-cod",
                  @"cpio":    @"application/x-cpio",
                  @"crd":     @"application/x-mscardfile",
                  @"crl":     @"application/pkix-crl",
                  @"crt":     @"application/x-x509-ca-cert",
                  @"csh":     @"application/x-csh",
                  @"css":     @"text/css",
                  @"dcr":     @"application/x-director",
                  @"der":     @"application/x-x509-ca-cert",
                  @"dir":     @"application/x-director",
                  @"dll":     @"application/x-msdownload",
                  @"dms":     @"application/octet-stream",
                  @"doc":     @"application/msword",
                  @"docx":    @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                  @"dot":     @"application/msword",
                  @"dvi":     @"application/x-dvi",
                  @"dxr":     @"application/x-director",
                  @"eps":     @"application/postscript",
                  @"etx":     @"text/x-setext",
                  @"evy":     @"application/envoy",
                  @"exe":     @"application/octet-stream",
                  @"fif":     @"application/fractals",
                  @"flr":     @"x-world/x-vrml",
                  @"gif":     @"image/gif",
                  @"gtar":    @"application/x-gtar",
                  @"gz":      @"application/x-gzip",
                  @"h":       @"text/plain",
                  @"hdf":     @"application/x-hdf",
                  @"hlp":     @"application/winhlp",
                  @"hqx":     @"application/mac-binhex40",
                  @"hta":     @"application/hta",
                  @"htc":     @"text/x-component",
                  @"htm":     @"text/html",
                  @"html":    @"text/html",
                  @"htt":     @"text/webviewhtml",
                  @"ico":     @"image/x-icon",
                  @"ief":     @"image/ief",
                  @"iii":     @"application/x-iphone",
                  @"ins":     @"application/x-internet-signup",
                  @"isp":     @"application/x-internet-signup",
                  @"jfif":    @"image/pipeg",
                  @"jpe":     @"image/jpeg",
                  @"jpeg":    @"image/jpeg",
                  @"jpg":     @"image/jpeg",
                  @"js":      @"application/x-javascript",
                  @"json":    @"application/json",   // According to RFC 4627  // Also application/x-javascript text/javascript text/x-javascript text/x-json
                  @"latex":   @"application/x-latex",
                  @"lha":     @"application/octet-stream",
                  @"lsf":     @"video/x-la-asf",
                  @"lsx":     @"video/x-la-asf",
                  @"lzh":     @"application/octet-stream",
                  @"m":       @"text/plain",
                  @"m13":     @"application/x-msmediaview",
                  @"m14":     @"application/x-msmediaview",
                  @"m3u":     @"audio/x-mpegurl",
                  @"man":     @"application/x-troff-man",
                  @"mdb":     @"application/x-msaccess",
                  @"me":      @"application/x-troff-me",
                  @"mht":     @"message/rfc822",
                  @"mhtml":   @"message/rfc822",
                  @"mid":     @"audio/mid",
                  @"mny":     @"application/x-msmoney",
                  @"mov":     @"video/quicktime",
                  @"movie":   @"video/x-sgi-movie",
                  @"mp2":     @"video/mpeg",
                  @"mp3":     @"audio/mpeg",
                  @"mpa":     @"video/mpeg",
                  @"mpe":     @"video/mpeg",
                  @"mpeg":    @"video/mpeg",
                  @"mpg":     @"video/mpeg",
                  @"mpp":     @"application/vnd.ms-project",
                  @"mpv2":    @"video/mpeg",
                  @"ms":      @"application/x-troff-ms",
                  @"mvb":     @"    application/x-msmediaview",
                  @"nws":     @"message/rfc822",
                  @"oda":     @"application/oda",
                  @"p10":     @"application/pkcs10",
                  @"p12":     @"application/x-pkcs12",
                  @"p7b":     @"application/x-pkcs7-certificates",
                  @"p7c":     @"application/x-pkcs7-mime",
                  @"p7m":     @"application/x-pkcs7-mime",
                  @"p7r":     @"application/x-pkcs7-certreqresp",
                  @"p7s":     @"    application/x-pkcs7-signature",
                  @"pbm":     @"image/x-portable-bitmap",
                  @"pdf":     @"application/pdf",
                  @"pfx":     @"application/x-pkcs12",
                  @"pgm":     @"image/x-portable-graymap",
                  @"pko":     @"application/ynd.ms-pkipko",
                  @"pma":     @"application/x-perfmon",
                  @"pmc":     @"application/x-perfmon",
                  @"pml":     @"application/x-perfmon",
                  @"pmr":     @"application/x-perfmon",
                  @"pmw":     @"application/x-perfmon",
                  @"png":     @"image/png",
                  @"pnm":     @"image/x-portable-anymap",
                  @"pot":     @"application/vnd.ms-powerpoint",
                  @"vppm":    @"image/x-portable-pixmap",
                  @"pps":     @"application/vnd.ms-powerpoint",
                  @"ppt":     @"application/vnd.ms-powerpoint",
                  @"pptx":    @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
                  @"prf":     @"application/pics-rules",
                  @"ps":      @"application/postscript",
                  @"pub":     @"application/x-mspublisher",
                  @"qt":      @"video/quicktime",
                  @"ra":      @"audio/x-pn-realaudio",
                  @"ram":     @"audio/x-pn-realaudio",
                  @"ras":     @"image/x-cmu-raster",
                  @"rgb":     @"image/x-rgb",
                  @"rmi":     @"audio/mid",
                  @"roff":    @"application/x-troff",
                  @"rtf":     @"application/rtf",
                  @"rtx":     @"text/richtext",
                  @"scd":     @"application/x-msschedule",
                  @"sct":     @"text/scriptlet",
                  @"setpay":  @"application/set-payment-initiation",
                  @"setreg":  @"application/set-registration-initiation",
                  @"sh":      @"application/x-sh",
                  @"shar":    @"application/x-shar",
                  @"sit":     @"application/x-stuffit",
                  @"snd":     @"audio/basic",
                  @"spc":     @"application/x-pkcs7-certificates",
                  @"spl":     @"application/futuresplash",
                  @"src":     @"application/x-wais-source",
                  @"sst":     @"application/vnd.ms-pkicertstore",
                  @"stl":     @"application/vnd.ms-pkistl",
                  @"stm":     @"text/html",
                  @"svg":     @"image/svg+xml",
                  @"sv4cpio": @"application/x-sv4cpio",
                  @"sv4crc":  @"application/x-sv4crc",
                  @"swf":     @"application/x-shockwave-flash",
                  @"t":       @"application/x-troff",
                  @"tar":     @"application/x-tar",
                  @"tcl":     @"application/x-tcl",
                  @"tex":     @"application/x-tex",
                  @"texi":    @"application/x-texinfo",
                  @"texinfo": @"application/x-texinfo",
                  @"tgz":     @"application/x-compressed",
                  @"tif":     @"image/tiff",
                  @"tiff":    @"image/tiff",
                  @"tr":      @"application/x-troff",
                  @"trm":     @"application/x-msterminal",
                  @"tsv":     @"text/tab-separated-values",
                  @"txt":     @"text/plain",
                  @"uls":     @"text/iuls",
                  @"ustar":   @"application/x-ustar",
                  @"vcf":     @"text/x-vcard",
                  @"vrml":    @"x-world/x-vrml",
                  @"wav":     @"audio/x-wav",
                  @"wcm":     @"application/vnd.ms-works",
                  @"wdb":     @"application/vnd.ms-works",
                  @"wks":     @"application/vnd.ms-works",
                  @"wmf":     @"application/x-msmetafile",
                  @"wps":     @"application/vnd.ms-works",
                  @"wri":     @"application/x-mswrite",
                  @"wrl":     @"x-world/x-vrml",
                  @"wrz":     @"x-world/x-vrml",
                  @"xaf":     @"x-world/x-vrml",
                  @"xbm":     @"image/x-xbitmap",
                  @"xla":     @"application/vnd.ms-excel",
                  @"xlc":     @"application/vnd.ms-excel",
                  @"xlm":     @"application/vnd.ms-excel",
                  @"xls":     @"application/vnd.ms-excel",
                  @"xlsx":    @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                  @"xlt":     @"application/vnd.ms-excel",
                  @"xlw":     @"application/vnd.ms-excel",
                  @"xml":     @"text/xml",   // According to RFC 3023   // Also application/xml
                  @"xof":     @"x-world/x-vrml",
                  @"xpm":     @"image/x-xpixmap",
                  @"xwd":     @"image/x-xwindowdump",
                  @"z":      @"application/x-compress",
                  @"zip":     @"application/zip"};
    });
    return dict;
}

@end

@implementation NSString (MatchingScore)

- (float)scoreAgainst:(NSString *)otherString{
    return [self scoreAgainst:otherString fuzziness:nil];
}

- (float)scoreAgainst:(NSString *)otherString fuzziness:(NSNumber *)fuzziness{
    return [self scoreAgainst:otherString fuzziness:fuzziness options:NSStringMatchingOptionNone];
}

- (float)scoreAgainst:(NSString *)anotherString fuzziness:(NSNumber *)fuzziness options:(NSStringMatchingOptions)options{
    NSMutableCharacterSet *workingInvalidCharacterSet = [NSMutableCharacterSet lowercaseLetterCharacterSet];
    [workingInvalidCharacterSet formUnionWithCharacterSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    [workingInvalidCharacterSet addCharactersInString:@" "];
    NSCharacterSet *invalidCharacterSet = [workingInvalidCharacterSet invertedSet];
    
    NSString *string = [[[self decomposedStringWithCanonicalMapping] componentsSeparatedByCharactersInSet:invalidCharacterSet] componentsJoinedByString:@""];
    NSString *otherString = [[[anotherString decomposedStringWithCanonicalMapping] componentsSeparatedByCharactersInSet:invalidCharacterSet] componentsJoinedByString:@""];
    
    // If the string is equal to the abbreviation, perfect match.
    if([string isEqualToString:otherString]) return 1.0f;
    
    //if it's not a perfect match and is empty return 0
    if([otherString length] == 0) return 0.0f;
    
    float totalCharacterScore = 0;
    NSUInteger otherStringLength = [otherString length];
    NSUInteger stringLength = [string length];
    BOOL startOfStringBonus = NO;
    float otherStringScore;
    float fuzzies = 1;
    float finalScore;
    
    // Walk through abbreviation and add up scores.
    for(uint index = 0; index < otherStringLength; index++){
        float characterScore = 0.1;
        NSInteger indexInString = NSNotFound;
        NSString *chr;
        NSRange rangeChrLowercase;
        NSRange rangeChrUppercase;
        
        chr = [otherString substringWithRange:NSMakeRange(index, 1)];
        
        //make these next few lines leverage NSNotfound, methinks.
        rangeChrLowercase = [string rangeOfString:[chr lowercaseString]];
        rangeChrUppercase = [string rangeOfString:[chr uppercaseString]];
        
        if(rangeChrLowercase.location == NSNotFound && rangeChrUppercase.location == NSNotFound){
            if(fuzziness){
                fuzzies += 1 - [fuzziness floatValue];
            } else {
                return 0; // this is an error!
            }
            
        } else if (rangeChrLowercase.location != NSNotFound && rangeChrUppercase.location != NSNotFound){
            indexInString = MIN(rangeChrLowercase.location, rangeChrUppercase.location);
            
        } else if(rangeChrLowercase.location != NSNotFound || rangeChrUppercase.location != NSNotFound){
            indexInString = rangeChrLowercase.location != NSNotFound ? rangeChrLowercase.location : rangeChrUppercase.location;
            
        } else {
            indexInString = MIN(rangeChrLowercase.location, rangeChrUppercase.location);
            
        }
        
        // Set base score for matching chr
        
        // Same case bonus.
        if(indexInString != NSNotFound && [[string substringWithRange:NSMakeRange(indexInString, 1)] isEqualToString:chr]){
            characterScore += 0.1;
        }
        
        // Consecutive letter & start-of-string bonus
        if(indexInString == 0){
            // Increase the score when matching first character of the remainder of the string
            characterScore += 0.6;
            if(index == 0){
                // If match is the first character of the string
                // & the first character of abbreviation, add a
                // start-of-string match bonus.
                startOfStringBonus = YES;
            }
        } else if(indexInString != NSNotFound) {
            // Acronym Bonus
            // Weighing Logic: Typing the first character of an acronym is as if you
            // preceded it with two perfect character matches.
            if( [[string substringWithRange:NSMakeRange(indexInString - 1, 1)] isEqualToString:@" "] ){
                characterScore += 0.8;
            }
        }
        
        // Left trim the already matched part of the string
        // (forces sequential matching).
        if(indexInString != NSNotFound){
            string = [string substringFromIndex:indexInString + 1];
        }
        
        totalCharacterScore += characterScore;
    }
    
    if(options & NSStringMatchingOptionFavorSmallerWords) {
        // Weigh smaller words higher
        return totalCharacterScore / stringLength;
    }
    
    otherStringScore = totalCharacterScore / otherStringLength;
    
    if(options & NSStringMatchingOptionReducedLongStringPenalty) {
        // Reduce the penalty for longer words
        float percentageOfMatchedString = otherStringLength / stringLength;
        float wordScore = otherStringScore * percentageOfMatchedString;
        finalScore = (wordScore + otherStringScore) / 2;
        
    } else {
        finalScore = ((otherStringScore * ((float)(otherStringLength) / (float)(stringLength))) + otherStringScore) / 2;
    }
    
    finalScore = finalScore / fuzzies;
    
    if(startOfStringBonus && finalScore + 0.15 < 1){
        finalScore += 0.15;
    }
    
    return finalScore;
}

@end

@implementation NSString (Validating)

- (BOOL)matchesRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)isEmpty {
    return [self isKindOfClass:NSNull.class] || !self.length;
}

- (BOOL)containsWhitespace {
    return [self rangeOfString:@" "].length;
}

- (BOOL)containsEmoji {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return range.length;
}

- (BOOL)containsCharacterInString:(NSString *)inString {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:inString];
    return [self rangeOfCharacterFromSet:characterSet].length;
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

- (NSUInteger)replaceOccurrencesOfString:(NSString *)source withString:(NSString *)replacement {
    return [self replaceOccurrencesOfString:source withString:replacement options:0 range:NSMakeRange(0, self.length)];
}

- (NSUInteger)deleteOccurrencesOfString:(NSString *)string {
    return [self replaceOccurrencesOfString:string withString:@""];
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

