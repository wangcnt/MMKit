//
//  UIControlAdditions.h
//  MMUIKit
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UIControlEventsHandler)(id control);

@interface UIControl (Additions)

- (void)handleControlEvents:(UIControlEvents)controlEvents usingBlock:(UIControlEventsHandler)eventHandler;
- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;

@end
