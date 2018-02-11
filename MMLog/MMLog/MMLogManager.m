//
//  DDLogManager.m
//  DDLogDemo
//
//  Created by wangjian on 15/9/22.
//  Copyright © 2015年 qhfax. All rights reserved.
//

#import "MMLogManager.h"

@implementation MMLogManager
/**
 *  初始化
 *
 *  @return 日志系统管理器对象
 */
+(instancetype)sharedInstance
{
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
        self.fileLogger = [[DDFileLogger alloc] init];
        self.fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        self.fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        self.fileLogger.maximumFileSize = 1024 * 1024 * 2;
    }
    return self;
}

/**配置日志信息*/
- (void)config {
    MMLogFormatter *logFormatter = [[MMLogFormatter alloc] init];
    
    //1.发送日志语句到苹果的日志系统，它们显示在Console.app上
    //    [[DDASLLogger sharedInstance] setLogFormatter:logFormatter];
    //    [DDLog addLogger:[DDASLLogger sharedInstance]];//
    
    //2.把输出日志写到文件中
#if RELEASE
    DDFileLogger *fileLogger = [MMLogManager sharedInstance].fileLogger;
    fileLogger.logFormatter = logFormatter;
    [DDLog addLogger:fileLogger withLevel:DDLogLevelError];//错误的写到文件中
#endif
    
#if DEBUG
    //3.初始化DDLog日志输出，在这里，我们仅仅希望在xCode控制台输出
    DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
    ttyLogger.logFormatter = logFormatter;
    ttyLogger.colorsEnabled = YES;
    [ttyLogger setForegroundColor:DDMakeColor(255, 0, 0) backgroundColor:nil forFlag:DDLogFlagError];
    [ttyLogger setForegroundColor:DDMakeColor(125,200,80) backgroundColor:nil forFlag:DDLogFlagInfo];
    [ttyLogger setForegroundColor:DDMakeColor(200,100,200) backgroundColor:nil forFlag:DDLogFlagDebug];
    [DDLog addLogger:ttyLogger];//
#endif
    
    //4.添加数据库输出
    //    DDAbstractLogger *dateBaseLogger = [[DDAbstractLogger alloc] init];
    //    [dateBaseLogger setLogFormatter:logFormatter];
    //    [DDLog addLogger:dateBaseLogger];
}
/*获得系统日志的路径**/
- (NSArray *)getLogPath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * logPath = [docPath stringByAppendingPathComponent:@"Caches"];
    logPath = [logPath stringByAppendingPathComponent:@"Logs"];
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * fileList = [[NSArray alloc]init];
    fileList = [fileManger contentsOfDirectoryAtPath:logPath error:&error];
    NSMutableArray * listArray = [[NSMutableArray alloc]init];
    for(NSString * oneLogPath in fileList) {
        //带有工程名前缀的路径才是我们自己存储的日志路径
        if([oneLogPath hasPrefix:[NSBundle mainBundle].bundleIdentifier])
        {
            NSString * truePath = [logPath stringByAppendingPathComponent:oneLogPath];
            [listArray addObject:truePath];
        }
    }
    return listArray;
}
/**获取记录的日志文件的内容*/
- (NSMutableArray *)readLogContent {
    NSMutableArray *contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *paths = [self getLogPath];
    NSString *path = nil;
    NSData *data = nil;
    NSString *content = nil;
    for (int i = 0; i < paths.count; i++) {
        path = paths[i];
        data = [[NSData alloc] initWithContentsOfFile:path];
        content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [contentArray addObject:content];
    }
    return contentArray;
}
@end
