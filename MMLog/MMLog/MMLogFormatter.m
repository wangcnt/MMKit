//
//  MMLogFormater.m
//  MMLog
//
//  Created by wangjian on 15/9/21.
//  Copyright © 2015年 qhfax. All rights reserved.
//

#import "MMLogFormatter.h"

@implementation MMLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)message {
    NSString *level = nil;
    switch (message.flag) {
        case DDLogFlagError: {
            level = @"[ERROR]->";
            break;
        }
        case DDLogFlagWarning: {
            level = @"[WARN]-->";
            break;
        }
        case DDLogFlagInfo: {
            level = @"[INFO]--->";
            break;
        }
        case DDLogFlagDebug: {
            level = @"[DEBUG]---->";
            break;
        }
        case DDLogFlagVerbose: {
            level = @"[VBOSE]----->";
            break;
        }
        default:
            break;
    }
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss SSS";
    });
    return [NSString stringWithFormat:@""
            "Date       : %@\n"
            "File       : %@\n"
            "Function   : %@\n"
            "Line       : %ld\n"
            "Message    : %@\n\n",
            [dateFormatter stringFromDate:message.timestamp],
            message.file.lastPathComponent,
            message.function,
            message.line,
            message.message];
}

@end
