//
//  UIResponderAdditions.m
//  MMUIKit
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "UIResponderAdditions.h"

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UIResponderAdditions)

@implementation UIResponder (Additions)

- (NSArray<UIResponder *> *)responderChain {
    NSMutableArray *responders = [NSMutableArray array];
    [responders addObject:self.class];
    UIResponder *nextResponder = self;
    while ((nextResponder = [nextResponder nextResponder])) {
        [responders addObject:[nextResponder class]];
    }
    return responders;
}

- (NSString *)responderChainString {
    NSArray *responders = [self responderChain];
    __block NSString *result = @"Responder Chain:\n";
    __block int level = 0;
    [responders enumerateObjectsWithOptions:NSEnumerationReverse
                                 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                     if (level) {
                                         result = [result stringByAppendingString:@"|"];
                                         for (int i = 0; i < level; i++) {
                                             result = [result stringByAppendingString:@"----"];
                                         }
                                         result = [result stringByAppendingString:@" "];
                                     } else {
                                         result = [result stringByAppendingString:@"| "];
                                     }
                                     result = [result stringByAppendingFormat:@"%@ (%@)\n", obj, @(idx)];
                                     level++;
                                 }];
    return result;
}

@end
