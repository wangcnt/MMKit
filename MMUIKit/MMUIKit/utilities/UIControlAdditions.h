//
//  UIControlAdditions.h
//  MMUIKit
//
//  Created by WangQiang on 16/11/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^UIControlEventHandler)();

@interface UIControl(Additions)

@end

@interface UIControl (MMBlocks)

- (void)addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;

- (BOOL)hasEventHandlersForControlEvents:(UIControlEvents)controlEvents;

@end
