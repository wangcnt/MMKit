//
//  MMLogManager.h
//  MMLog
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMLogManager.h"
#import "MMCompressedLogFileManager.h"
#import "MMLogFormatter.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MMLogDefines.h"
#import <MMFoundation/MMDefines.h>

@interface MMLogManager ()
@property (nonatomic,strong) DDFileLogger *fileLogger;
@end

@implementation MMLogManager

+ (instancetype)sharedInstance {
    static MMLogManager *logmanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logmanager = [[self alloc] init];
    });
    return logmanager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        MMCompressedLogFileManager *logFileManager = [[MMCompressedLogFileManager alloc] init];
        _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
        [self defaultConfiguration];
    }
    return self;
}

- (void)setMaximumFileSize:(unsigned long long)maximumFileSize {
    if(_maximumFileSize != maximumFileSize) {
        _maximumFileSize = maximumFileSize;
        _fileLogger.maximumFileSize = _maximumFileSize;
    }
}

- (void)setRollingFrequency:(NSTimeInterval)rollingFrequency {
    if(_rollingFrequency != rollingFrequency) {
        _rollingFrequency = rollingFrequency;
        _fileLogger.rollingFrequency = _rollingFrequency;
    }
}

- (void)setMaximumNumberOfLogFiles:(int)maximumNumberOfLogFiles {
    if(_maximumNumberOfLogFiles != maximumNumberOfLogFiles) {
        _maximumNumberOfLogFiles = maximumNumberOfLogFiles;
        _fileLogger.logFileManager.maximumNumberOfLogFiles = _maximumNumberOfLogFiles;
    }
}

- (void)defaultConfiguration {
    MMLogFormatter *logFormatter = [[MMLogFormatter alloc] init];
    
    //1. 发送日志语句到苹果的日志系统，它们显示在Console.app上
    //    [[DDASLLogger sharedInstance] setLogFormatter:logFormatter];
    //    [DDLog addLogger:[DDASLLogger sharedInstance]];//
    
    //2. 把输出日志写到文件中
//#if RELEASE
    _fileLogger.logFormatter = logFormatter;
    _fileLogger.maximumFileSize = 1024 * 1024 *2;
    _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 3;
    [DDLog addLogger:_fileLogger withLevel:ddLogLevel];//错误的写到文件中
//#endif
    
#if DEBUG
    //3. 初始化DDLog日志输出，在这里，我们仅仅希望在xCode控制台输出
    DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
    ttyLogger.logFormatter = logFormatter;
    ttyLogger.colorsEnabled = YES;
    [ttyLogger setForegroundColor:DDMakeColor(255, 0, 0) backgroundColor:nil forFlag:DDLogFlagError];
    [ttyLogger setForegroundColor:DDMakeColor(125,200,80) backgroundColor:nil forFlag:DDLogFlagInfo];
    [ttyLogger setForegroundColor:DDMakeColor(200,100,200) backgroundColor:nil forFlag:DDLogFlagDebug];
    [DDLog addLogger:ttyLogger];//
#endif
    
    //4. 添加数据库输出
    //    DDAbstractLogger *dateBaseLogger = [[DDAbstractLogger alloc] init];
    //    [dateBaseLogger setLogFormatter:logFormatter];
    //    [DDLog addLogger:dateBaseLogger];
}

- (NSArray *)logPaths {
    NSString *logDirectory = self.fileLogger.logFileManager.logsDirectory;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *contents = [fileManger contentsOfDirectoryAtPath:logDirectory error:&error];
    NSMutableArray *paths = [[NSMutableArray alloc]init];
    for(NSString *path in contents) {
        //带有工程名前缀的路径才是我们自己存储的日志路径
        if([path hasPrefix:mm_application_name()]) {
            NSString *truePath = [logDirectory stringByAppendingPathComponent:path];
            [paths addObject:truePath];
        }
    }
    return paths;
}

- (NSMutableArray<NSString *> *)readLogs {
    NSMutableArray<NSString *> *logArray = [NSMutableArray<NSString *> array];
    NSArray *paths = [self logPaths];
    NSString *path = nil;
    NSData *data = nil;
    NSString *content = nil;
    for (int i = 0; i < paths.count; i++) {
        path = paths[i];
        data = [[NSData alloc] initWithContentsOfFile:path];
        content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [logArray addObject:content];
    }
    return logArray;
}
@end
