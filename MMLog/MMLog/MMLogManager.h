//
//  MMLogManager.h
//  MMLog
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDFileLogger;

@interface MMLogManager : NSObject

@property (nonatomic,strong) DDFileLogger *fileLogger;

+ (instancetype)sharedInstance;

- (void)config;

- (NSArray*)getLogPaths;
- (NSMutableArray *)readLogContent;

@end
