//
//  QTLabel.h
//  QTUIKit
//
//  Created by Mark on 15/11/16.
//  Copyright © 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    QTTextVerticalAlignmentMiddle,
    QTTextVerticalAlignmentTop,
    QTTextVerticalAlignmentBottom
}QTTextVerticalAlignment;

@interface QTLabel : UILabel

@property (nonatomic, assign) QTTextVerticalAlignment    verticalAlignment;

@end
