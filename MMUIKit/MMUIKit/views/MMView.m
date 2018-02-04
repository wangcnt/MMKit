//
//  MMView.m
//  MMime
//
//  Created by Mark on 15/6/24.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMView.h"

#import "UIViewAdditions.h"

@implementation MMView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self mm_commonInitialize];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)mm_commonInitialize
{
    _contentsEdges = UIEdgeInsetsMake(15, 10, 15, 10);
    
    _contentsOffset = CGPointMake(5, 10);
}

- (void)reloadData
{
    // 子类实现
}

@end
