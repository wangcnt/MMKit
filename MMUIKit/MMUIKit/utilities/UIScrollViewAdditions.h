//
//  UIScrollViewAdditions.h
//  MMUIKit
//
//  Created by Mark on 2018/3/10.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Additions)

- (void)scrollToTop;
- (void)scrollToBottom;
- (void)scrollToLeft;
- (void)scrollToRight;

- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)scrollToLeftAnimated:(BOOL)animated;
- (void)scrollToRightAnimated:(BOOL)animated;

@end
