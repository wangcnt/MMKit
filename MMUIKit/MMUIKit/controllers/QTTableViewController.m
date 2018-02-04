//
//  QTTableViewController.m
//  QTime
//
//  Created by Mark on 15/6/24.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "QTTableViewController.h"

#import "UIViewAdditions.h"
#import "QTTableViewCell.h"

@interface QTTableViewController ()
{
    UITableViewStyle                        _style;
}

@end

@implementation QTTableViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if(self = [super init])
    {
        _style = style;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    {
        _tableView = [[QTTableView alloc] initWithFrame:self.view.bounds style:_style];
        
        _tableView.delegate             = self;
        _tableView.dataSource           = self;
        _tableView.tableFooterView      = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delaysContentTouches = NO;
        
        [self.view addSubview:_tableView];
        
        [self setupTableHeaderView];
        
        [self setupTableFooterView];
    }
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    if(_clearsSelectionOnViewWillAppear)
//    {
//        NSArray *selectedIndexPaths = [_tableView indexPathsForSelectedRows];
//        
//        [selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
//            
//            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
//        }];
//    }
//}

- (void)setRefreshControl:(UIRefreshControl *)refreshControl
{
    if(_refreshControl != refreshControl)
    {
        [_refreshControl removeFromSuperview];
        
        _refreshControl = refreshControl;
        
        [_tableView addSubview:_refreshControl];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableHeaderView
{
    
}

- (void)setupTableFooterView
{
    
}

#pragma mark ---------------------------------------------------------------------------------------
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(YES
       && [cell isKindOfClass:[QTTableViewCell class]]
       && _tableView.separatorStyle == UITableViewCellSeparatorStyleSingleLine)
    {
        QTTableViewCell *c = (QTTableViewCell *)cell;
        
        if(c.indexPath.row+1 == [tableView numberOfRowsInSection:c.indexPath.section])
        {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)])
            {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
//            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
//            {
//                [cell setPreservesSuperviewLayoutMargins:NO];
//            }
//            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
//            {
//                [cell setLayoutMargins:UIEdgeInsetsZero];
//            }
        }
    }
}

#pragma mark ---------------------------------------------------------------------------------------
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

@end
