//
//  UISearchBarAdditions.h
//  QTTime
//
//  Created by Mark on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UISearchBar(Additions)

- (void)setTitle:(NSString *)title forState:(UIControlState)state;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

@end
