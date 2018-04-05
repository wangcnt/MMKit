//
//  MMLabel.h
//  MMUIKit
//
//  Created by Mark on 15/11/16.
//  Copyright © 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UILabelAdditions.h"
#import "UIViewAdditions.h"
#import "UIResponderAdditions.h"

typedef enum
{
    MMTextVerticalAlignmentMiddle,
    MMTextVerticalAlignmentTop,
    MMTextVerticalAlignmentBottom
}MMTextVerticalAlignment;

@interface MMLabel : UILabel

@property (nonatomic, assign) MMTextVerticalAlignment verticalAlignment;

@end
