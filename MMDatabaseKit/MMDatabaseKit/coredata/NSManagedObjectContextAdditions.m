//
//  NSManagedContextAdditions.m
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/24.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSManagedObjectContextAdditions.h"
#import <MMLog/MMLog.h>

@implementation NSManagedObjectContext (Save)

- (void)mm_save:(NSError * __autoreleasing *)error {
    if(![self hasChanges])  {
        return;
    }
    [self performBlock:^{
        BOOL successed = [self save:error] && !error;
        if(successed) {
            NSManagedObjectContext *parentContext = self.parentContext;
            if(parentContext) {
                [parentContext mm_save:error];
            }
        } else {
            MMLogError(@"CoreData save: with error: %@", *error);
        }
    }];
}

- (BOOL)mm_saveAndWait:(NSError * __autoreleasing *)error {
    __block BOOL successed = NO;
    if([self hasChanges]) {
        [self performBlockAndWait:^{
            successed = [self save:error] && !error;
            if(successed) {
                NSManagedObjectContext *parentContext = self.parentContext;
                if(parentContext) {
                    successed = [parentContext mm_saveAndWait:error];
                }
            } else {
                MMLogError(@"CoreData saveAndWait: with error: %@", *error);
            }
        }];
    } else {
        successed = YES;
    }
    return successed;
}

@end

@implementation NSManagedObjectContext (CRUD)

// Create
- (id)insertWithEntityName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

// Retrieve
- (NSInteger)countWithEntityName:(NSString *)entityName {
    return [self countWithEntityName:entityName usingPredicate:nil];
}

- (NSInteger)countWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    request.resultType = NSDictionaryResultType;
    request.predicate = predicate;
    request.returnsObjectsAsFaults = YES;
    
    NSError *error;
    NSUInteger count = [self countForFetchRequest:request error:&error];
    return count;
}

- (NSArray *)findWithEntityName:(NSString *)entityName {
    return [self findWithEntityName:entityName usingPredicate:nil];
}

- (NSArray *)findWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate {
    return [self findWithEntityName:entityName usingPredicate:predicate sortDescriptors:nil];
}

- (NSArray *)findWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    return [self findWithEntityName:entityName usingPredicate:predicate sortDescriptors:sortDescriptors returnsAsFaults:NO];
}

- (NSArray *)findWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors returnsAsFaults:(BOOL)returnsAsFaults {
    return [self findWithEntityName:entityName usingPredicate:predicate sortDescriptors:sortDescriptors returnsAsFaults:returnsAsFaults propertiesToFetch:nil];
}

- (NSArray *)findWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors returnsAsFaults:(BOOL)returnsAsFaults propertiesToFetch:(NSArray *)propertiesToFetch {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    request.predicate = predicate;
    request.sortDescriptors = sortDescriptors;
    request.propertiesToFetch = propertiesToFetch;
    request.returnsObjectsAsFaults = returnsAsFaults;
    NSError *error;
    NSArray *results = [self executeFetchRequest:request error:&error];
    return results;
}


// Update

// Delete
- (NSError *)deleteWithEntityName:(NSString *)entityName {
    return [self deleteWithEntityName:entityName usingPredicate:nil];
}

- (NSError *)deleteWithEntityName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    request.includesPropertyValues = NO; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *objects = [self executeFetchRequest:request error:&error];
    //error handling goes here
    for (NSManagedObject * obj in objects) {
        [self deleteObject:obj];
    }
    [self save:&error];
    return error;
}

@end
