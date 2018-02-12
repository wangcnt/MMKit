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

#if DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else 
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

@interface MMLogManager : NSObject

@property (nonatomic,strong) DDFileLogger *fileLogger;

+ (instancetype)sharedInstance;

- (void)config;

- (NSArray*)getLogPaths;
- (NSMutableArray *)readLogContent;

@end
