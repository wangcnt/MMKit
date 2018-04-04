//
//  UIControlAdditions.m
//  MMUIKit
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "UIControlAdditions.h"

#import <objc/runtime.h>

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UIControlAdditions)

static const void *UIControlEventsHandlerArray = &UIControlEventsHandlerArray;

@interface UIControlEventsHandlerWrapper : NSObject
@property (nonatomic, copy) UIControlEventsHandler eventHandler;
@property (nonatomic, assign) UIControlEvents controlEvents;

- (void)invoke:(id)sender;

@end

@implementation UIControlEventsHandlerWrapper

- (void)invoke:(id)sender {
    if (self.eventHandler) {
        self.eventHandler(sender);
    }
}

@end

@implementation UIControl (Additions)

- (void)handleControlEvents:(UIControlEvents)controlEvents usingBlock:(UIControlEventsHandler)eventHandler {
    NSMutableArray *handlerArray = [self handlerArray];
    
    UIControlEventsHandlerWrapper *wrapper = [[UIControlEventsHandlerWrapper alloc] init];
    wrapper.eventHandler = eventHandler;
    wrapper.controlEvents = controlEvents;
    [handlerArray addObject:wrapper];
    
    [self addTarget:wrapper action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents {
    NSMutableArray *handlerArray = [self handlerArray];
    NSMutableArray *removing = [NSMutableArray arrayWithCapacity:[handlerArray count]];
    
    for(UIControlEventsHandlerWrapper *target in handlerArray) {
        if (target.controlEvents == controlEvents) {
            [removing addObject:target];
            [self removeTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
        }
    };
    
    [handlerArray removeObjectsInArray:removing];
}

- (NSMutableArray *)handlerArray {
    NSMutableArray *handlerArray = objc_getAssociatedObject(self, UIControlEventsHandlerArray);
    if (!handlerArray) {
        handlerArray = [NSMutableArray array];
        objc_setAssociatedObject(self, UIControlEventsHandlerArray, handlerArray, OBJC_ASSOCIATION_RETAIN);
    }
    return handlerArray;
}

@end
