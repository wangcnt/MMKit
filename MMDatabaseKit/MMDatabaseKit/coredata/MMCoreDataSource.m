//
//  MMCoreDataSource.m
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/24.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMCoreDataSource.h"

#import <MMLog/MMLog.h>
#import "NSManagedObjectContextAdditions.h"

@interface MMCoreDataSource () {
    NSInteger _fetchLimit;
}
@end

@implementation MMCoreDataSource

- (void)performFetch {
    self.request.predicate = self.predicate;
    self.request.fetchLimit = _fetchLimit;
    self.request.sortDescriptors = _sortDescriptors;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error] || error) {
        MMLogError(@"Fetch error: %@", error);
    } else {
        [self resetCount];
    }
}

- (NSPredicate *)predicate {
    return nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if(!self.request) {
        MMLogError(@"Request not existed.");
        return nil;
    }
    if(!self.context) {
        MMLogError(@"Context not existed.");
        return nil;
    }
    if(self.context.concurrencyType != NSMainQueueConcurrencyType) {
        MMLogError(@"Context must be main concurrency type.");
        return nil;
    }
    if (!_fetchController) {
        _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.request managedObjectContext:self.context sectionNameKeyPath:self.sectionKeyPath cacheName:nil];
        _fetchController.delegate = self;
    }
    return _fetchController;
}

- (void)nextPage {
    _fetchLimit += _pageSize;
    [self performFetch];
}

- (void)resetPage {
    _fetchLimit = 0;
    _count = 0;
}

- (void)reset {
    [self resetPage];
    _fetchController = nil;
}

- (NSInteger)count {
    if(_count == 0) {
        _count = [self resetCount];
    }
    return _count;
}

- (NSInteger)resetCount {
    return [self.fetchController.managedObjectContext countWithEntityName:self.request.entityName usingPredicate:self.predicate];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Fetched Results Controller Delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if(self.delegate && [self.delegate respondsToSelector:@selector(dataSourceWillChangeContent:)]) {
        [self.delegate dataSourceWillChangeContent:self];
    }
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];

    [self resetCount];
    if(self.delegate && [self.delegate respondsToSelector:@selector(dataSourceDidChangeContent:)]) {
        [self.delegate dataSourceDidChangeContent:self];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default: break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default: break;
    }
}

@synthesize tableView = _tableView;
@synthesize fetchController = _fetchController;
@synthesize request = _request;
@synthesize context = _context;
@synthesize sectionKeyPath = _sectionKeyPath;
@synthesize count = _count;
@synthesize delegate = _delegate;
@synthesize pageSize = _pageSize;
@synthesize sortDescriptors = _sortDescriptors;

@end
