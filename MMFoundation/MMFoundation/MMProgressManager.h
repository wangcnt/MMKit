//
//  MMProgressManager.h
//  MMime
//
//  Created by Mark on 15/6/23.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MMProgressValueDidChangeHandler)(NSProgress *progress);

@interface MMProgressManager : NSObject

+ (instancetype)defaultManager;

/**
 *  监听NSProgress的进度变化，并通知出去
 *
 *  @param progress   progress description
 *  @param identifier 此NSProgress的唯一标识，用于取出NSProgress以删除掉监听器
 *  @param handler    回调处理
 */
- (void)observeProgress:(NSProgress *)progress withIdentifier:(id)identifier handler:(MMProgressValueDidChangeHandler)handler;

/**
 *  根据标识删除对应NSProgress的监听事件
 *
 *  @param identifier 标识
 */
- (void)removeObserverWithIdentifier:(id)identifier;

/**
 *  删除掉所有的监听
 */
- (void)removeAllProgressObservers;

@end
