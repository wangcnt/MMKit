//
//  MMProxy.h
//  MMFoundation
//
//  Created by Mark on 2018/3/1.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  多協議動態代理，暂不支持代理Block属性
 *
 */
@interface MMProxy : NSProxy

- (instancetype)init;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

- (BOOL)hasDelegateThatRespondsToSelector:(SEL)selector;

@end
