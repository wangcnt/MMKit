//
//  NSInvocationAdditions.m
//  MMFoundation
//
//  Created by Mark on 2018/3/1.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "NSInvocationAdditions.h"

#import "MMDefines.h"

__mm_synth_dummy_class__(NSInvocationAdditions)

@implementation NSInvocation (Additions)

- (NSInvocation *)duplicatedInvocation {
    NSMethodSignature *signature = self.methodSignature;

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = self.selector;
    
    NSUInteger i, count = signature.numberOfArguments;
    for (i = 2; i < count; i++) {
        const char *type = [signature getArgumentTypeAtIndex:i];
        if (*type == *@encode(BOOL)) {
            BOOL value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(char) || *type == *@encode(unsigned char)) {
            char value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(short) || *type == *@encode(unsigned short)) {
            short value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(int) || *type == *@encode(unsigned int)) {
            int value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(long) || *type == *@encode(unsigned long)) {
            long value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(long long) || *type == *@encode(unsigned long long)) {
            long long value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(double)) {
            double value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(float)) {
            float value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == '@') {
            void *value;
            [self getArgument:&value atIndex:i];
            [invocation setArgument:&value atIndex:i];
        } else if (*type == '^') {
            void *block;
            [self getArgument:&block atIndex:i];
            [invocation setArgument:&block atIndex:i];
        } else {
            NSString *reason = [NSString stringWithFormat:@"Argument %lu to method %@ - Type(%c) not supported", (unsigned long)(i - 2), NSStringFromSelector(self.selector), *type];
            [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        }
    }
    [invocation retainArguments];
    return invocation;
}

@end
