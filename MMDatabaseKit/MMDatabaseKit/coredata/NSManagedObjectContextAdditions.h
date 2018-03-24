//
//  NSManagedObjectContext.h
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/24.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Save)

- (void)mm_save:(NSError **)error;

- (BOOL)mm_saveAndWait:(NSError **)error;

@end

@interface NSManagedObjectContext (CRUD)

// Create
- (id)insertWithEntityName:(NSString *)entityName;

// Retrieve
- (NSInteger)countWithEntityName:(NSString *)entityName;
- (NSInteger)countWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate;

- (NSArray *)findWithEntityName:(NSString *)entityName;
- (NSArray *)findWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate;
- (NSArray *)findWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)findWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors returnsAsFaults:(BOOL)returnsAsFaults;
- (NSArray *)findWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors returnsAsFaults:(BOOL)returnsAsFaults propertiesToFetch:(NSArray *)propertiesToFetch;

// Update

// Delete
- (NSError *)deleteWithEntityName:(NSString *)entityName;
- (NSError *)deleteWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate;

@end
