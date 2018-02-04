//
//  UIControlAdditions.m
//  MMUIKit
//
//  Created by WangQiang on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "UIControlAdditions.h"

#import <objc/runtime.h>

static const void *MMControlHandlersKey = &MMControlHandlersKey;

@implementation UIControl (Additions)

@end

#pragma mark Private

@interface MMControlWrapper : NSObject <NSCopying>

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^handler)(id sender);

@end

@implementation MMControlWrapper

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
    self = [super init];
    if (!self) return nil;
    
    self.handler = handler;
    self.controlEvents = controlEvents;
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[MMControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender
{
    self.handler(sender);
}

@end

#pragma mark Category

@implementation UIControl (BlocksKit)

- (void)addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
    if(!handler)    return;
    
    NSMutableDictionary *events = objc_getAssociatedObject(self, MMControlHandlersKey);
    if (!events)
    {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, MMControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    
    MMControlWrapper *target = [[MMControlWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
    [handlers addObject:target];
    
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableDictionary *events = objc_getAssociatedObject(self, MMControlHandlersKey);
    
    if (!events)
    {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, MMControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];
    
    if (!handlers) return;
    
    [handlers enumerateObjectsUsingBlock:^(id sender, BOOL *stop) {
        
        [self removeTarget:sender action:NULL forControlEvents:controlEvents];
    }];
    
    [events removeObjectForKey:key];
}

- (BOOL)hasEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableDictionary *events = objc_getAssociatedObject(self, MMControlHandlersKey);
    
    if (!events)
    {
        events = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, MMControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];
    
    if (!handlers) return NO;
    
    return !!handlers.count;
}

@end
