//
//  MMDatabase.m
//  MMime
//
//  Created by Mark on 15/6/8.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMDatabase.h"

@interface MMDatabase()

@end

@implementation MMDatabase

- (instancetype)init
{
    if(self = [super init])
    {
        _readQueue = dispatch_queue_create("com.mark.MMime.queue.database.query", DISPATCH_QUEUE_CONCURRENT);
        
        _writeQueue = dispatch_queue_create("com.mark.MMime.queue.database.update", DISPATCH_QUEUE_CONCURRENT);
        
        _completionQueue = dispatch_get_main_queue();
    }
    
    return self;
}

- (void)openDatabaseWithFileAtPath:(NSString *)path completion:(MMDatabaseOpenCompletion)completion
{}

- (void)createOrUpgradeTablesWithClasses:(NSArray *)classes
{}

- (void)closeDatabaseWithCompletion:(MMDatabaseCloseCompletion)completion
{}

- (void)save:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{}

- (void)update:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{}

- (void)saveOrUpdate:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{}

- (void)removeModel:(id<MMPersistable>)model completion:(MMDatabaseRemoveCompletion)completion
{}

- (void)removeModels:(NSArray *)models completion:(MMDatabaseRemoveCompletion)completion
{}

- (void)removeModelWithClass:(__unsafe_unretained Class<MMPersistable>)clazz byId:(NSString *)objectId
                  completion:(MMDatabaseRemoveCompletion)completion
{}


- (void)executeUpdate:(NSString *)sqlString completion:(MMDatabaseUpdateCompletion)completion
{}

- (void)upgradeBySql:(NSString *)sqlString completion:(MMDatabaseUpgradeCompletion)completion
{}

- (id<MMPersistable>)findModelForClass:(__unsafe_unretained Class<MMPersistable>)clazz byId:(NSString *)objectId
{
    return nil;
}

- (void)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withParameters:(NSDictionary *)parameters
                completion:(MMDatabaseQueryCompletion)completion
{}

- (NSArray *)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withParameters:(NSDictionary *)parameters
{
    return @[];
}

- (void)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withConditions:(NSString *)conditions
                completion:(MMDatabaseQueryCompletion)completion
{}

- (NSArray *)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withConditions:(NSString *)conditions
{
    return @[];
}

- (void)executeQuery:(NSString *)sqlString forClass:(__unsafe_unretained Class<MMPersistable>)clazz
      withCompletion:(MMDatabaseQueryCompletion)completion
{}

- (NSArray *)executeQuery:(NSString *)sqlString forClass:(__unsafe_unretained Class<MMPersistable>)clazz
{
    return @[];
}

- (NSUInteger)countOfModelsForClass:(Class<MMPersistable>)clazz withConditions:(NSString *)conditions
{
    return 0;
}

@synthesize path = _path;
@synthesize opened = _opened;

@end
