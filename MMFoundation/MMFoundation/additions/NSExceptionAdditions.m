//
//  NSExceptionAdditions.m
//  MMFoundation
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "NSExceptionAdditions.h"

#include <execinfo.h>

#import "MMDefines.h"

__mm_synth_dummy_class__(NSExceptionAdditions)

@implementation NSException (Additions)

- (NSArray *)backtrace
{
    NSArray *addresses = self.callStackReturnAddresses;
    unsigned count = (int)addresses.count;
    void **stack = malloc(count * sizeof(void *));
    
    for (unsigned i = 0; i < count; ++i) {
        stack[i] = (void *)[addresses[i] longValue];
    }
    
    char **strings = backtrace_symbols(stack, count);
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; ++i) {
        [ret addObject:@(strings[i])];
    }
    
    free(stack);
    free(strings);
    
    return ret;
}

@end
