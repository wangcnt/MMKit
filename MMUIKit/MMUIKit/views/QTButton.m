//
//  QTButton.m
//  QTime
//
//  Created by Mark on 15/6/12.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "QTButton.h"

#import "UIViewAdditions.h"

@implementation QTButton

- (void)setImagePosition:(QTButtonImagePosition)imagePosition
{
    if(_imagePosition != imagePosition)
    {
        _imagePosition = imagePosition;
        
        [self layoutSubviews];
    }
}

- (void)setDistanceBetweenSubviews:(float)distanceBetweenSubviews
{
    if(!_distanceBetweenSubviews != distanceBetweenSubviews)
    {
        _distanceBetweenSubviews = distanceBetweenSubviews;
        
        [self layoutSubviews];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(_imagePosition == QTButtonImagePositionTop)
    {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        self.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        
        // text
        CGRect newFrame = self.titleLabel.frame;
        
        newFrame.origin.x   = 0;
        newFrame.origin.y   = self.height - newFrame.size.height - 5; // 上移5像素
        newFrame.size.width = self.width;
        
        self.titleLabel.frame         = newFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
        
        // image
        float height = self.height - self.titleLabel.height - _distanceBetweenSubviews;
        
        float width  = self.imageView.width;
        
        if(self.imageView.height !=0 )
        {
            width = height * self.imageView.width / self.imageView.height;
        }
        
        newFrame = CGRectMake((self.width - width)/2, 0, width, height);
        
        self.imageView.frame = newFrame;
    }
}

@end
