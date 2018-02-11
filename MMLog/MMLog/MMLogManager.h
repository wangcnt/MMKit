//
//  DDLogManager.h
//  DDLogDemo
//
//  Created by wangjian on 15/9/22.
//  Copyright © 2015年 qhfax. All rights reserved.
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
