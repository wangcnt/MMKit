//
//  MMTableViewCell.h
//  MMime
//
//  Created by Mark on 15/6/25.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewAdditions.h"
#import "UIResponderAdditions.h"

@interface MMTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) NSIndexPath *indexPath;
@property (nonatomic, weak, readonly) UITableView *tableView;

@end
