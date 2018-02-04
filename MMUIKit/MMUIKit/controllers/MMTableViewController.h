//
//  MMTableViewController.h
//  MMime
//
//  Created by Mark on 15/6/24.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

/**
 *  基于列表的基类
 */
#import <MMUIKit/MMViewController.h>

#import <MMUIKit/MMTableView.h>

@interface MMTableViewController : MMViewController
<UITableViewDelegate, UITableViewDataSource>
{
    @protected
    MMTableView                                         *_tableView;
}

@property (nonatomic, strong, readonly) MMTableView      *tableView;

@property (nonatomic, assign          ) BOOL              clearsSelectionOnViewWillAppear;

@property (nonatomic, strong          ) UIRefreshControl *refreshControl;

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)setupTableHeaderView;

- (void)setupTableFooterView;

@end
