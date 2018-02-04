//
//  QTTableViewController.h
//  QTime
//
//  Created by Mark on 15/6/24.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

/**
 *  基于列表的基类
 */
#import <QTUIKit/QTViewController.h>

#import <QTUIKit/QTTableView.h>

@interface QTTableViewController : QTViewController
<UITableViewDelegate, UITableViewDataSource>
{
    @protected
    QTTableView                                         *_tableView;
}

@property (nonatomic, strong, readonly) QTTableView      *tableView;

@property (nonatomic, assign          ) BOOL              clearsSelectionOnViewWillAppear;

@property (nonatomic, strong          ) UIRefreshControl *refreshControl;

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)setupTableHeaderView;

- (void)setupTableFooterView;

@end
