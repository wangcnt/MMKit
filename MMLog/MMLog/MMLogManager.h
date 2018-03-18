//
//  MMLogManager.h
//  MMLog
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMLogManager : NSObject

// Congifurations for file logger.
@property (nonatomic, assign) unsigned long long maximumFileSize;   ///< Unit B, Default = 2M
@property (nonatomic, assign) NSTimeInterval rollingFrequency;  ///< Unit second, Default = 24h
@property (nonatomic, assign) int maximumNumberOfLogFiles;  ///< Default = 3
@property (nonatomic, strong) NSString *logsDirectory;   ///< Root directory for log.

// Apple console app
@property (nonatomic, assign) BOOL ASLEnabled;    ///< Log in apple console panel.
@property (nonatomic, assign) BOOL TTYEnabled;    ///< Log in xcode console panel.
@property (nonatomic, assign) BOOL dbEnabled __deprecated_msg("Not implemented.");     ///< Save logs into database.

+ (instancetype)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *logPaths;

@end
