//
//  UIResponderAdditions.h
//  MMUIKit
//
//  Created by Mark on 2018/3/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIResponder (Additions)

- (NSArray<UIResponder *> *)responderChain;
- (NSString *)responderChainString;

@end
