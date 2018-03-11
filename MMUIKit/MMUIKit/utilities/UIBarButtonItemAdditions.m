//
//  UIBarButtonItemAdditions.m
//  MMUIKit
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "UIBarButtonItemAdditions.h"

#import <objc/runtime.h>

static char *const UIBarButtonItemHandlerKey = "UIBarButtonItemHandlerKey";

@implementation UIBarButtonItem (Additions)

- (void)invokeHandler {
    UIBarButtonItemHandler block = self.handler;
    if (block) {
        block(self);
    }
}

- (UIBarButtonItemHandler)handler {
    return objc_getAssociatedObject(self, UIBarButtonItemHandlerKey);
}

- (void)setActionBlock:(UIBarButtonItemHandler)handler {
    if (handler != self.handler) {
        [self willChangeValueForKey:@"handler"];
        objc_setAssociatedObject(self, UIBarButtonItemHandlerKey, handler, OBJC_ASSOCIATION_COPY);
        self.target = self;
        self.action = @selector(invokeHandler);
        [self didChangeValueForKey:@"handler"];
    }
}

@end
