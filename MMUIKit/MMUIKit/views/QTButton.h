//
//  QTButton.h
//  QTime
//
//  Created by Mark on 15/6/12.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    QTButtonImagePositionDefault,       // left
    QTButtonImagePositionTop
}QTButtonImagePosition;

@interface QTButton : UIButton

/**
 *  纵向排列时，imageView和titleLabel之间的间距
 */
@property (nonatomic, assign) float                 distanceBetweenSubviews;

@property (nonatomic, assign) QTButtonImagePosition imagePosition;

@end
