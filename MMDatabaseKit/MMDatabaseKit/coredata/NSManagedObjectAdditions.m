//
//  NSManagedObjectAdditions.m
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/24.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "NSManagedObjectContextAdditions.h"

@implementation NSManagedObject (Additions)

+ (NSString *)entityName {
    return [NSString stringWithCString:object_getClassName(self) encoding:NSASCIIStringEncoding];
}

+ (instancetype)insertInContext:(NSManagedObjectContext*)context {
    return [context insertWithEntityName:[self entityName]];
}

+ (NSError *)deleteInContext:(NSManagedObjectContext*)context {
    return [self.class deleteUsingPredicate:nil inContext:context];
}

+ (NSError *)deleteUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext*)context {
    return [context deleteWithEntityName:[self entityName] usingPredicate:predicate];
}

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context {
    return [self.class findUsingPredicate:nil inContext:context];
}

+ (NSArray *)findUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context {
    return [self.class findUsingPredicate:predicate sortDescriptors:nil inContext:context];
}

+ (NSArray *)findUsingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context {
    return [self.class findUsingPredicate:predicate sortDescriptors:sortDescriptors returnsAsFaults:NO inContext:context];
}

+ (NSArray *)findUsingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors returnsAsFaults:(BOOL)returnsAsFaults inContext:(NSManagedObjectContext *)context {
    return [self.class findUsingPredicate:predicate sortDescriptors:sortDescriptors returnsAsFaults:returnsAsFaults propertiesToFetch:nil inContext:context];
}

+ (NSArray *)findUsingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors returnsAsFaults:(BOOL)returnsAsFaults propertiesToFetch:(NSArray *)propertiesToFetch inContext:(NSManagedObjectContext *)context {
     return [context findWithEntityName:[self entityName] usingPredicate:predicate sortDescriptors:sortDescriptors returnsAsFaults:returnsAsFaults propertiesToFetch:propertiesToFetch];
}

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context {
    return [self.class countUsingPredicate:nil inContext:context];
}

+ (NSUInteger)countUsingPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context {
    return [context countWithEntityName:[self entityName] usingPredicate:predicate];
}

@end
