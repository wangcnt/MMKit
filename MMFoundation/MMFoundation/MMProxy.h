//
//  MMProxy.h
//  MMFoundation
//
//  Created by Mark on 2018/3/1.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  多協議動態代理
 *  
 *  屬性初始化寫在-initialize裏，init僅提供代理入口, 內部將調用-initialize
 */
@interface MMProxy : NSProxy

- (instancetype)init;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

- (BOOL)hasDelegateThatRespondsToSelector:(SEL)selector;

@end
