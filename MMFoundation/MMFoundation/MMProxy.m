//
//  MMProxy.m
//  MMFoundation
//
//  Created by Mark on 2018/3/1.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMProxy.h"

#import "NSInvocationAdditions.h"
#import "MMDefines.h"

@interface MMProxy ()
@property (nonatomic, strong) NSMutableArray *delegates_;
@end

@implementation MMProxy

- (instancetype)init {
    _delegates_ = [NSMutableArray arrayWithCapacity:2];
    return self;
}

- (NSArray *)delegates {
    return [_delegates_ copy];
}

- (void)addDelegate:(id)delegate {
    if(delegate && ![_delegates_ containsObject:delegate]) {
        [_delegates_ addObject:delegate];
    }
}

- (void)removeDelegate:(id)delegate {
    [_delegates_ removeObject:delegate];
}

- (void)removeAllDelegates {
    [_delegates_ removeAllObjects];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    for (id delegate in _delegates_) {
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
    for (id delegate in _delegates_) {
        if ([delegate respondsToSelector:selector]) {
            NSInvocation *duplicatedInvocation = [invocation duplicatedInvocation];
            if([self invocationShouldBeInvoked:duplicatedInvocation withTarget:delegate]) {
                [duplicatedInvocation invokeWithTarget:delegate];
            }
        }
    }
}

- (BOOL)invocationShouldBeInvoked:(NSInvocation *)invocation withTarget:(id)target {
    return YES;
}

- (BOOL)hasDelegateThatRespondsToSelector:(SEL)selector {
    for(id delegate in _delegates_) {
        if([delegate respondsToSelector:selector]) {
            return YES;
        }
    }
    return NO;
}

@end
