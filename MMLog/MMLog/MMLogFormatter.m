//
//  MMLogFormater.m
//  MMLog
//
//  Created by wangjian on 15/9/21.
//  Copyright © 2015年 qhfax. All rights reserved.
//

#import "MMLogFormatter.h"

@implementation MMLogFormatter

-(NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *loglevel = nil;
    switch (logMessage.flag) {
        case DDLogFlagError: {
            loglevel = @"[ERROR]->";
            break;
        }
        case DDLogFlagWarning: {
            loglevel = @"[WARN]-->";
            break;
        }
        case DDLogFlagInfo: {
            loglevel = @"[INFO]--->";
            break;
        }
        case DDLogFlagDebug: {
            loglevel = @"[DEBUG]---->";
            break;
        }
        case DDLogFlagVerbose: {
            loglevel = @"[VBOSE]----->";
            break;
        }
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@ %@___line[%ld]__%@",
            loglevel,
            logMessage->_function,
            logMessage->_line,
            logMessage->_message];
}
@end
