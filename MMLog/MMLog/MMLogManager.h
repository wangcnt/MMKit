//
//  MMLogManager.h
//  MMLog
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"
#import "MMLogFormatter.h"
#import "DDLegacyMacros.h"

#if DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else 
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

@interface MMLogManager : NSObject

@property (nonatomic,strong) DDFileLogger *fileLogger;

+ (instancetype)sharedInstance;


/**配置日志信息*/
- (void)config;


/**获得系统日志的路径*/
- (NSArray*)getLogPath;

/**获取记录的日志文件的内容*/
- (NSMutableArray *)readLogContent;

@end
