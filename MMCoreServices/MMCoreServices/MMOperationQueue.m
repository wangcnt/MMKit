//
//  MMOperationQueue.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/29.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMOperationQueue.h"

#import "MMOperation.h"
#import <MMFoundation/MMDefines.h>

@implementation MMOperationQueue

- (void)addOperation:(NSOperation *)op {
    Protocol *protocol = @protocol(MMOperation);
    NSAssert([op conformsToProtocol:protocol], @"Operation MUST conforms to protocol: %@.", NSStringFromProtocol(protocol));
    
    SEL configurationSelector = @selector(configuration);
    NSAssert([op respondsToSelector:configurationSelector], @"Operation MUST responds to %@.", NSStringFromSelector(configurationSelector));
    
    SEL errorSelector = @selector(error);
    NSAssert([op respondsToSelector:errorSelector], @"Operation MUST responds to %@.", NSStringFromSelector(errorSelector));
    
    id<MMOperation> operation = (id<MMOperation>)op;
    __mm_exe_block__(operation.stepHandler, NO, MMRequestStepWaiting);
    
    [super addOperation:op];
}

- (void)addOperations:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)) {
    NSAssert(1==2, @"Please use -addOperation: with %@-protocolled NSOperation", NSStringFromProtocol(@protocol(MMOperation)));
    // do nothing.
}

- (void)addOperationWithBlock:(void (^)(void))block {
    NSAssert(1==2, @"Please use -addOperation: with %@-protocolled NSOperation", NSStringFromProtocol(@protocol(MMOperation)));
    // do nothing.
}

@end
