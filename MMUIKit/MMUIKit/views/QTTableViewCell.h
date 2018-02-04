//
//  QTTableViewCell.h
//  QTime
//
//  Created by Mark on 15/6/25.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    QTTableViewCellSeparatorStyleNone,
    QTTableViewCellSeparatorStyleLine
}QTTableViewCellSeparatorStyle;

@interface QTTableViewCell : UITableViewCell
{

}

@property (nonatomic, strong          ) NSIndexPath *indexPath;

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
