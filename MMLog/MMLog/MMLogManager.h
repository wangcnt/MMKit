//
//  MMLogManager.h
//  MMLog
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMLogManager : NSObject

@property (nonatomic, assign) unsigned long long maximumFileSize;   ///< Default = 2M
@property (nonatomic, assign) NSTimeInterval rollingFrequency;  ///< Default = 24h
@property (nonatomic, assign) int maximumNumberOfLogFiles;  ///< Default = 3

+ (instancetype)sharedInstance;

- (NSArray *)logPaths;
- (NSMutableArray<NSString *> *)readLogs;

@end
