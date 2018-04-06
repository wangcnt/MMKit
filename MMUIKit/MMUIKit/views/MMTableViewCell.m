//
//  MMTableViewCell.m
//  MMime
//
//  Created by Mark on 15/6/25.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMTableViewCell.h"

#import "UIViewAdditions.h"

@interface MMTableViewCell()
@end

@implementation MMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self enumerateSubviewsRecursively:YES usingBlock:^(UIView *subview, BOOL *stop) {
            if([subview isKindOfClass:UIScrollView.class]) {
                ((UIScrollView *)subview).delaysContentTouches = NO;
                *stop = YES;
            }
        }];
        self.clipsToBounds = YES;
    }
    return self;
}

- (UITableView *)tableView {
    if(!_tableView) {
        UIView *superview = self.superview;
        while (![superview isKindOfClass:UITableView.class]) {
            superview = superview.superview;
        }
        _tableView = (UITableView *)superview;
    }
    return _tableView;
}

- (NSIndexPath *)indexPath {
    return [self.tableView indexPathForCell:self];
}

@synthesize tableView = _tableView;
@synthesize indexPath = _indexPath;
            
@end
