//
//  MMProxy.m
//  MMFoundation
//
//  Created by Mark on 2018/3/1.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMProxy.h"

#import "NSInvocationAdditions.h"

@interface MMProxy ()
@property (nonatomic, strong) NSMutableArray *delegates;
@end

@implementation MMProxy

- (instancetype)init {
    [self initialize];
    return self;
}

- (void)initialize {
    _delegates = [NSMutableArray arrayWithCapacity:2];
    // override by subproxy
}

- (void)addDelegate:(id)delegate {
    if(delegate && ![_delegates containsObject:delegate]) {
        [_delegates addObject:delegate];
    }
}

- (void)removeDelegate:(id)delegate {
    [_delegates removeObject:delegate];
}

- (void)removeAllDelegates {
    [_delegates removeAllObjects];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    for (id delegate in _delegates) {
        NSMethodSignature *result = [delegate methodSignatureForSelector:selector];
        if (result) {
            return result;
        }
    }
    
    // This causes a crash...
    // return [super methodSignatureForSelector:aSelector];
    
    // This also causes a crash...
    // return nil;
    
    return [[self class] instanceMethodSignatureForSelector:@selector(doNothing)];
}

- (void)doNothing {
    // do nothing.
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL selector = invocation.selector;
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:selector]) {
            NSInvocation *duplicatedInvocation = [invocation duplicate];
            [duplicatedInvocation invokeWithTarget:delegate];
        }
    }
}

@end
