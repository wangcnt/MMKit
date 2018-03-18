//
//  MMLogDefines.h
//  MMLog
//
//  Created by Mark on 2018/2/13.
//  Copyright © 2018年 Mark. All rights reserved.
//

#ifndef MMLogDefines_h
#define MMLogDefines_h

#import "CocoaLumberjack.h"

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#if DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

#define MMLogError(frmt, ...)   do { NSLog(frmt, ##__VA_ARGS__); LOG_MAYBE(NO, LOG_LEVEL_DEF, DDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__); } while (0)

#define MMLogWarning(frmt, ...) do { NSLog(frmt, ##__VA_ARGS__); LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__); } while (0)

#define MMLogInfo(frmt, ...)    do { NSLog(frmt, ##__VA_ARGS__); LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__); } while (0)

#define MMLogDebug(frmt, ...)   do { NSLog(frmt, ##__VA_ARGS__); LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__); } while (0)

#define MMLogVerbose(frmt, ...) do { NSLog(frmt, ##__VA_ARGS__); LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__); } while (0)


#endif /* MMLogDefines_h */
