//
//  NSManagedObjectAdditions.h
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/24.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Additions)

+ (instancetype)insertInContext:(NSManagedObjectContext*)context;

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *)findUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findUsingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findUsingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors returnsAsFaults:(BOOL)returnsAsFaults inContext:(NSManagedObjectContext *)context;
+ (NSArray *)findUsingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors returnsAsFaults:(BOOL)returnsAsFaults propertiesToFetch:(NSArray *)propertiesToFetch inContext:(NSManagedObjectContext *)context;

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context;
+ (NSUInteger)countUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;

+ (NSError *)deleteInContext:(NSManagedObjectContext*)context;
+ (NSError *)deleteUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext*)context;

@end
