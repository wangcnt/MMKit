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
@property (nonatomic, strong) DDFileLogger *fileLogger;
@property (nonatomic, strong) MMCompressedLogFileManager *compressedFileManager;
@property (nonatomic, strong) id<DDLogFormatter> logFormatter;
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
        _maximumFileSize = 1024 * 1024 * 2; 
        _rollingFrequency = 60 * 60 * 24;
        _maximumNumberOfLogFiles = 3;
        
        _logFormatter = [[MMLogFormatter alloc] init];
        
        [self resetFileLogger];
    }
    return self;
}

- (void)resetFileLogger {
    [DDLog removeLogger:_fileLogger];
    
    _compressedFileManager = [[MMCompressedLogFileManager alloc] initWithLogsDirectory:_logsDirectory];
    _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:_compressedFileManager];
    
    [DDLog addLogger:_fileLogger withLevel:ddLogLevel];
}

- (void)setLogsDirectory:(NSString *)logsDirectory {
    if(_logsDirectory != logsDirectory) {
        _logsDirectory = logsDirectory;
        [self resetFileLogger];
        [self config];
    }
}

- (void)setMaximumFileSize:(unsigned long long)maximumFileSize {
    if(_maximumFileSize != maximumFileSize) {
        _maximumFileSize = maximumFileSize;
        [self config];
    }
}

- (void)setMaximumNumberOfLogFiles:(int)maximumNumberOfLogFiles {
    if(_maximumNumberOfLogFiles != maximumNumberOfLogFiles) {
        _maximumNumberOfLogFiles = maximumNumberOfLogFiles;
        [self config];
    }
}

- (void)setRollingFrequency:(NSTimeInterval)rollingFrequency {
    if(_rollingFrequency != rollingFrequency)  {
        _rollingFrequency = rollingFrequency;
        [self config];
    }
}

- (void)setASLEnabled:(BOOL)ASLEnabled {
#if DEBUG
    if(_ASLEnabled != ASLEnabled) {
        _ASLEnabled = ASLEnabled;
        DDASLLogger *aslLogger = [DDASLLogger sharedInstance];
        if(_ASLEnabled) {
            self.TTYEnabled = NO;
            [DDLog addLogger:aslLogger];
        } else {
            [DDLog removeLogger:aslLogger];
        }
    }
#endif
}

- (void)setTTYEnabled:(BOOL)TTYEnabled {
#if DEBUG
    if(_TTYEnabled != TTYEnabled) {
        _TTYEnabled = TTYEnabled;
        
        DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
        if(_TTYEnabled) {
            self.ASLEnabled = NO;
            ttyLogger.colorsEnabled = YES;
            [ttyLogger setForegroundColor:DDMakeColor(255, 0, 0) backgroundColor:nil forFlag:DDLogFlagError];
            [ttyLogger setForegroundColor:DDMakeColor(125,200,80) backgroundColor:nil forFlag:DDLogFlagInfo];
            [ttyLogger setForegroundColor:DDMakeColor(200,100,200) backgroundColor:nil forFlag:DDLogFlagDebug];
            [DDLog addLogger:ttyLogger];
        } else {
            [DDLog removeLogger:ttyLogger];
        }
    }
#endif
}

- (void)config {
    // 1. Apple console panel.
//    [DDASLLogger sharedInstance].logFormatter = _logFormatter;
    
    // 2. App file system.
    if(!_fileLogger) {
        [self resetFileLogger];
    }
    _fileLogger.logFormatter = _logFormatter;
    _fileLogger.maximumFileSize = _maximumFileSize;
    _fileLogger.rollingFrequency = _rollingFrequency; // 24 hour rolling
    _fileLogger.logFileManager.maximumNumberOfLogFiles = _maximumNumberOfLogFiles;
    
    // 3. Xcode console panel.
//    [DDTTYLogger sharedInstance].logFormatter = _logFormatter;
    
    // 4. App database.
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
