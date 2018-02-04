//
//  QTTableViewCell.m
//  QTime
//
//  Created by Mark on 15/6/25.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "QTTableViewCell.h"

#import "UIViewAdditions.h"

@interface QTTableViewCell()
{
}

@end

@implementation QTTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        for (UIView *currentView in self.subviews)
        {
            if([currentView isKindOfClass:[UIScrollView class]])
            {
                ((UIScrollView *)currentView).delaysContentTouches = NO;
                
                break;
            }
        }
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (UITableView *)tableView
{
    return (UITableView *)[self tableViewWithView:self.superview];
}
            
- (UIView *)tableViewWithView:(UIView *)view
{
    if([view isKindOfClass:[UITableView class]] || !view) return view;
                    
    return [self tableViewWithView:view.superview];
}

- (NSIndexPath *)indexPath
{
    return _indexPath ? _indexPath : [self.tableView indexPathsForRowsInRect:self.frame].firstObject ;
}
            
@end
