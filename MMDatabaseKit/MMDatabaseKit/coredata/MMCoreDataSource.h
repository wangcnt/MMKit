//
//  MMCoreDataSource.h
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/24.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>
#import <UIKit/UITableView.h>

@protocol MMCoreDataSourceDelegate;

/*!
 * UITableView with CoreData data source.
 */
@protocol MMCoreDataSource <NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchController;
@property (nonatomic, strong, readonly) NSFetchRequest *request;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSString *sectionKeyPath;
@property (nonatomic, strong) NSArray *sortDescriptors;
@property (nonatomic, assign) int pageSize;

@property (nonatomic, assign, readonly) NSInteger count;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<MMCoreDataSourceDelegate> delegate;


- (NSPredicate *)predicate;

- (void)performFetch;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)nextPage;
- (void)resetPage;

- (void)reset;

@end

@interface MMCoreDataSource : NSObject <MMCoreDataSource>

@end

@protocol MMCoreDataSourceDelegate <NSObject>

- (void)dataSourceWillChangeContent:(MMCoreDataSource *)dataSource;
- (void)dataSourceDidChangeContent:(MMCoreDataSource *)dataSource;

@end
