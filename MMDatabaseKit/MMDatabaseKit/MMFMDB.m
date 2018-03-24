//
//  MMFMDB.m
//  MMime
//
//  Created by Mark on 15/6/8.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMFMDB.h"

#import "FMDB.h"
#import "MMSqlGenerator.h"

@interface MMFMDB()
{
    FMDatabaseQueue                     *_queue;
    
    BOOL                                 _opened;
}

@end

@implementation MMFMDB

- (BOOL)opened
{
    return _queue != nil;
}

- (void)openDatabaseWithFileAtPath:(NSString *)path completion:(MMDatabaseOpenCompletion)completion
{
    dispatch_block_t block = ^{
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        if(completion)
        {
            dispatch_async(_completionQueue, ^{
                
                completion(self, path, YES);
            });
        }
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else // 无回调，则在主线程中执行操作，但必须是阻塞的，因为不阻塞的话，可能这里还没执行完，就执行到调用此方法的下一行了
    {
        block();
    }
}


- (void)createOrUpgradeTablesWithClasses:(NSArray *)classes
{
    [_queue inDatabase:^(FMDatabase *db) {
        
        [classes enumerateObjectsUsingBlock:^(Class clazz, NSUInteger idx, BOOL *stop) {
            
            if([clazz conformsToProtocol:@protocol(MMPersistable)])
            {
                NSString *sql = [clazz creationSql];
                
                [db executeUpdate:sql];
                
                if([clazz upgradeSqls])
                {
                    NSArray *upgradeSqls = [clazz upgradeSqls];
                    
                    [upgradeSqls enumerateObjectsUsingBlock:^(NSString *upgradeSql, NSUInteger idx, BOOL *stop) {
                        
                        [db executeUpdate:upgradeSql];
                    }];
                }
            }
        }];
    }];
}

- (void)closeDatabaseWithCompletion:(MMDatabaseCloseCompletion)completion
{
    dispatch_block_t block = ^{
        
        [_queue close];
        
        if(completion)
        {
            dispatch_async(_completionQueue, ^{
                
                completion(self, YES);
            });
        }
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else // 无回调，则在主线程中执行操作，但必须是阻塞的，因为不阻塞的话，可能这里还没执行完，就执行到调用此方法的下一行了
    {
        block();
    }
}

- (void)save:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{
    dispatch_block_t block = ^{
        
        NSArray *columns = [model toDatabaseDictionary].allKeys;
        
        NSString *sql = [[MMSqlGenerator defaultGenerator] generateInsertSqlWithModel:model columns:columns];
        NSArray *arguments = [[MMSqlGenerator defaultGenerator] generateInsertArgumentsWithModel:model columns:columns];
        
        [_queue inDatabase:^(FMDatabase *db) {
            
            BOOL successfully = [db executeUpdate:sql withArgumentsInArray:arguments];
            
            if(completion)
            {
                dispatch_async(_completionQueue, ^{
                    
                    completion(self, model, sql, successfully);
                });
            }
        }];
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else // 无回调，则在主线程中执行操作，但必须是阻塞的，因为不阻塞的话，可能这里还没执行完，就执行到调用此方法的下一行了
    {
        block();
    }
}

- (void)update:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{
    dispatch_block_t block = ^{
        
        NSString *sql = [[MMSqlGenerator defaultGenerator] generateUpdateSqlWithModel:model
                                                                        operationType:MMDatabaseOperationTypeUpdate];
        
        [_queue inDatabase:^(FMDatabase *db) {
            
            BOOL successfully = [db executeUpdate:sql withParameterDictionary:[model toDatabaseDictionary]];
            
            if(completion)
            {
                dispatch_async(_completionQueue, ^{
                    
                    completion(self, model, sql, successfully);
                });
            }
        }];
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else // 无回调，则在主线程中执行操作，但必须是阻塞的，因为不阻塞的话，可能这里还没执行完，就执行到调用此方法的下一行了
    {
        block();
    }
}

- (void)saveOrUpdate:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{
    MMSqlGenerator *generator = [MMSqlGenerator defaultGenerator];
    
    dispatch_block_t block = ^{
        
        [_queue inDatabase:^(FMDatabase *db) {
            
            Class clazz = [generator getClassForModel:model];
            
            NSString *sql = [generator generateQuerySqlWithParameters:@{@"modelId" : [model modelId]} forClass:clazz];
            
            FMResultSet *resultSet = [db executeQuery:sql];
            BOOL exists = resultSet.next;
            [resultSet close];
            
            BOOL successfully = NO;
            if(exists)
            {
                sql = [generator generateUpdateSqlWithModel:model operationType:MMDatabaseOperationTypeUpdate];
                
                successfully = [db executeUpdate:sql withParameterDictionary:[model toDatabaseDictionary]];
            }
            else
            {
                NSArray *columns = [model toDatabaseDictionary].allKeys;
                
                sql = [generator generateInsertSqlWithModel:model columns:columns];
                NSArray *arguments = [generator generateInsertArgumentsWithModel:model columns:columns];
                
                successfully = [db executeUpdate:sql withArgumentsInArray:arguments];
            }
            
            if(completion)
            {
                dispatch_async(_completionQueue, ^{
                    
                    completion(self, model, sql, successfully);
                });
            }
        }];
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else
    {
        block();
    }
}

- (void)saveOrUpdate1:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{
    dispatch_block_t block = ^{
        
        Class clazz = [[MMSqlGenerator defaultGenerator] getClassForModel:model];
        
        id<MMPersistable> m = [self findModelForClass:clazz byId:model.modelId];
        
        if(m)
        {
            [self update:model completion:completion];
        }
        else
        {
            [self save:model completion:completion];
        }
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else
    {
        block();
    }
}

- (BOOL)removeModel:(id<MMPersistable>)model
{
    __block BOOL successfully = NO;
    
    NSString *sql = [[MMSqlGenerator defaultGenerator] generateUpdateSqlWithModel:model
                                                                    operationType:MMDatabaseOperationTypeDelete];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        successfully = [db executeUpdate:sql];
    }];
    
    return successfully;
}

- (void)removeModel:(id<MMPersistable>)model completion:(MMDatabaseRemoveCompletion)completion
{
    dispatch_block_t block = ^{
        
        BOOL successfully = [self removeModel:model];
        
        if(completion)
        {
            dispatch_async(_completionQueue, ^{
                
                completion(self, @[model], successfully);
            });
        }
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else // 无回调，则在主线程中执行操作，但必须是阻塞的，因为不阻塞的话，可能这里还没执行完，就执行到调用此方法的下一行了
    {
        block();
    }
}

- (void)removeModels:(NSArray *)models completion:(MMDatabaseRemoveCompletion)completion
{
    dispatch_block_t block = ^{
        
        [models enumerateObjectsUsingBlock:^(id<MMPersistable> model, NSUInteger idx, BOOL *stop) {
            
            [self removeModel:model];
        }];
        
        if(completion)
        {
            dispatch_async(_completionQueue, ^{
                
                completion(self, models, YES);
            });
        }
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else // 无回调，则在主线程中执行操作，但必须是阻塞的，因为不阻塞的话，可能这里还没执行完，就执行到调用此方法的下一行了
    {
        block();
    }
}

- (void)removeModelWithClass:(__unsafe_unretained Class<MMPersistable>)clazz byId:(NSString *)objectId
                  completion:(MMDatabaseRemoveCompletion)completion
{
    id<MMPersistable> model = [self findModelForClass:clazz byId:objectId];
    
    [self removeModel:model completion:completion];
}

- (void)executeUpdate:(NSString *)sqlString completion:(MMDatabaseUpdateCompletion)completion
{
    dispatch_block_t block = ^{
        
        [_queue inDatabase:^(FMDatabase *db) {
            
            BOOL successfully = [db executeUpdate:sqlString];
            
            if(completion)
            {
                dispatch_async(_completionQueue, ^{
                    
                    completion(self, nil, sqlString, successfully);
                });
            }
        }];
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else // 无回调，则在主线程中执行操作，但必须是阻塞的，因为不阻塞的话，可能这里还没执行完，就执行到调用此方法的下一行了
    {
        block();
    }
}

- (void)upgradeBySql:(NSString *)sqlString completion:(MMDatabaseUpgradeCompletion)completion
{
    dispatch_block_t block = ^{
        
        [_queue inDatabase:^(FMDatabase *db) {
            
            BOOL successfully = [db executeUpdate:sqlString];
            
            if(completion)
            {
                dispatch_async(_completionQueue, ^{
                    
                    completion(self, sqlString, successfully);
                });
            }
        }];
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_writeQueue, block);
    }
    else block();
}

- (id<MMPersistable>)findModelForClass:(__unsafe_unretained Class<MMPersistable>)clazz byId:(NSString *)objectId
{
    if(!objectId)   return nil;
    
    NSString *sql = [[MMSqlGenerator defaultGenerator] generateQuerySqlWithParameters:@{@"modelId" : objectId} forClass:clazz];
    
    __block NSDictionary *dic = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:sql];
        
        if(resultSet.next)
        {
            dic = resultSet.resultDictionary;
        }
        
        [resultSet close];
    }];
    
    if(dic.count == 0)  return nil;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    return [clazz modelWithDatabaseDictionary:dictionary];
}

- (void)executeQuery:(NSString *)sqlString forClass:(__unsafe_unretained Class<MMPersistable>)clazz
      withCompletion:(MMDatabaseQueryCompletion)completion
{
    [self findModelsForClass:clazz withSqlString:sqlString completion:completion];
}

- (void)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withParameters:(NSDictionary *)parameters
                completion:(MMDatabaseQueryCompletion)completion
{
    NSString *sql = [[MMSqlGenerator defaultGenerator] generateQuerySqlWithParameters:parameters forClass:clazz];
    
    [self findModelsForClass:clazz withSqlString:sql completion:completion];
}

- (NSArray *)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withParameters:(NSDictionary *)parameters
{
    NSString *sql = [[MMSqlGenerator defaultGenerator] generateQuerySqlWithParameters:parameters forClass:clazz];
    
    return [self executeQuery:sql forClass:clazz];
}

- (void)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz
            withConditions:(NSString *)conditions
                completion:(MMDatabaseQueryCompletion)completion
{
    NSString *sql = [[MMSqlGenerator defaultGenerator] generateQuerySqlWithConditions:conditions forClass:clazz];
    
    [self findModelsForClass:clazz withSqlString:sql completion:completion];
}

- (NSArray *)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withConditions:(NSString *)conditions
{
    NSString *sql = [[MMSqlGenerator defaultGenerator] generateQuerySqlWithConditions:conditions forClass:clazz];
    
    return [self executeQuery:sql forClass:clazz];
}

- (void)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withSqlString:(NSString *)sql
                completion:(MMDatabaseQueryCompletion)completion
{
    dispatch_block_t block = ^{
        
        NSArray *results = [self executeQuery:sql forClass:clazz];
        
        if(completion)
        {
            dispatch_async(_completionQueue, ^{
                
                completion(self, results, sql);
            });
        }
    };
    
    // 有回调，则后台队列执行操作，并回到回调队列里执行回调
    if(completion)
    {
        dispatch_async(_readQueue, block);
    }
}

- (NSArray<id<MMPersistable>> *)executeQuery:(NSString *)sql forClass:(__unsafe_unretained Class<MMPersistable>)clazz
{
    NSMutableArray<id<MMPersistable>> *results = [NSMutableArray<id<MMPersistable>> array];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:sql];
        
        while (resultSet.next) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultSet.resultDictionary];
            
            id<MMPersistable> model = [clazz modelWithDatabaseDictionary:dic];
            
            [results addObject:model];
        }
        
        [resultSet close];
    }];
        
    return results;
}

- (NSUInteger)countOfModelsForClass:(Class<MMPersistable>)clazz withConditions:(NSString *)conditions;
{
    NSString *sql = [[MMSqlGenerator defaultGenerator] generateQuerySqlWithConditions:conditions forClass:clazz];
    
    __block NSUInteger count = 0;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:sql];
        
        while (resultSet.next) {
            
            count ++;
        }
        
        [resultSet close];
    }];
    
    return count;
}

@end
