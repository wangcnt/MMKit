//
//  MMOperationQueue.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/29.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMOperationQueue.h"

#import "MMOperation.h"

@implementation MMOperationQueue

- (void)addOperation:(NSOperation *)op {
    NSAssert([op conformsToProtocol:@protocol(MMOperation)], @"Operation MUST conforms to protocol: MMOperation.");
    
    NSAssert([op respondsToSelector:@selector(configuration)], @"Operation MUST responds to @selector(configuration);");
    NSAssert([op respondsToSelector:@selector(error)], @"Operation MUST responds to @selector(error);");
    [super addOperation:op];
}

- (void)addOperations:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) {
    NSAssert(1==2, @"Please use -addOperation: with MMOperation");
    // do nothing.
}

- (void)addOperationWithBlock:(void (^)(void))block {
    NSAssert(1==2, @"Please use -addOperation: with MMOperation.");
    // do nothing.
}

@end
