//
//  MMDatabaseManager.m
//  MMTime
//
//  Created by Mark on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMDatabaseManager.h"

#import "MMDatabase.h"
#import "MMFMDatabase.h"
#import "MMSPODatabase.h"
#import "MMCoreDatabase.h"
#import "MMOriginalDatabase.h"

@interface MMDatabaseManager()

@property (nonatomic, strong) MMDatabase                *database;

@property (nonatomic, strong) NSMutableDictionary       *databaseDictionary;

@end

@implementation MMDatabaseManager

+ (instancetype)defaultManager
{
    static MMDatabaseManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[MMDatabaseManager alloc] init];
    });
    
    return manager;
}

- (void)setType:(MMDatabaseType)type
{
    if(_type != type)
    {
        _type = type;
        
        _database = [self databaseWithType:_type];
        
        _databaseDictionary = [NSMutableDictionary dictionary];
    }
}

- (MMDatabase *)openedDatabaseWithPath:(NSString *)path
{
    if(!path.length)        return nil;
    
    if(_type == MMDatabaseTypeNone) return nil;
    
    if([_databaseDictionary.allKeys containsObject:path])   return _databaseDictionary[path];
    
    MMDatabase *database = [self databaseWithType:_type];
    
    [database openDatabaseWithFileAtPath:path completion:nil];
    
    return database;
}

- (MMDatabase *)databaseWithType:(MMDatabaseType)type
{
    if(type == MMDatabaseTypeFMDB)
    {
        return [[MMFMDatabase alloc] init];
    }
    else if(type == MMDatabaseTypeCoreData)
    {
        return [[MMCoreDatabase alloc] init];
    }
    else if(type == MMDatabaseTypeSqlitePersistentObject)
    {
        return [[MMSPODatabase alloc] init];
    }
    else if(type == MMDatabaseTypeOriginal)
    {
        return [[MMOriginalDatabase alloc] init];
    }
    
    return nil;
}

- (MMDatabase *)database
{
    return _database;
}

- (void)openDatabaseWithFileAtPath:(NSString *)path completion:(MMDatabaseOpenCompletion)completion
{
    if(completion)
    {
        [_database openDatabaseWithFileAtPath:path completion:^(MMDatabase *database, NSString *path, BOOL successfully) {
            
            if(successfully && database)
            {
                _databaseDictionary[path] = database;
            }
            
            completion(database, path, successfully);
        }];
    }
    else
    {
        [_database openDatabaseWithFileAtPath:path completion:nil];
        
        _databaseDictionary[path] = _database;
    }
}

- (void)createOrUpgradeTablesWithClasses:(NSArray *)classes
{
    [_database createOrUpgradeTablesWithClasses:classes];
}

- (void)closeDatabaseWithCompletion:(MMDatabaseCloseCompletion)completion
{
    [_database closeDatabaseWithCompletion:completion];
    
    NSArray *keys = [_databaseDictionary allKeysForObject:_database];
    
    [_databaseDictionary removeObjectsForKeys:keys];
}

- (void)save:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{
    [_database save:model completion:completion];
}

- (void)saveOrUpdate:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{
    [_database saveOrUpdate:model completion:completion];
}

- (void)update:(id<MMPersistable>)model completion:(MMDatabaseUpdateCompletion)completion
{
    [_database update:model completion:completion];
}

- (void)removeModel:(id<MMPersistable>)model completion:(MMDatabaseRemoveCompletion)completion
{
    [_database removeModel:model completion:completion];
}

- (void)removeModels:(NSArray *)models completion:(MMDatabaseRemoveCompletion)completion
{
    [_database removeModels:models completion:completion];
}

- (void)removeModelWithClass:(__unsafe_unretained Class<MMPersistable>)clazz byId:(NSString *)objectId
                  completion:(MMDatabaseRemoveCompletion)completion
{
    [_database removeModelWithClass:clazz byId:objectId completion:completion];
}

- (void)executeUpdate:(NSString *)sqlString completion:(MMDatabaseUpdateCompletion)completion
{
    [_database executeUpdate:sqlString completion:completion];
}

- (void)upgradeBySql:(NSString *)sqlString completion:(MMDatabaseUpgradeCompletion)completion
{
    [_database upgradeBySql:sqlString completion:completion];
}

- (id<MMPersistable>)findModelForClass:(__unsafe_unretained Class<MMPersistable>)clazz byId:(NSString *)objectId
{
    return [_database findModelForClass:clazz byId:objectId];
}

- (void)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withParameters:(NSDictionary *)parameters
                     completion:(MMDatabaseQueryCompletion)completion
{
    return [_database findModelsForClass:clazz withParameters:parameters completion:completion];
}

- (NSArray *)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withParameters:(NSDictionary *)parameters
{
    return [_database findModelsForClass:clazz withParameters:parameters];
}

- (void)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withConditions:(NSString *)conditions
                completion:(MMDatabaseQueryCompletion)completion
{
    [_database findModelsForClass:clazz withConditions:conditions completion:completion];
}

- (NSArray *)findModelsForClass:(__unsafe_unretained Class<MMPersistable>)clazz withConditions:(NSString *)conditions
{
    return [_database findModelsForClass:clazz withConditions:conditions];
}

- (void)executeQuery:(NSString *)sqlString forClass:(__unsafe_unretained Class<MMPersistable>)clazz
      withCompletion:(MMDatabaseQueryCompletion)completion
{
    [_database executeQuery:sqlString forClass:clazz withCompletion:completion];
}

- (NSArray *)executeQuery:(NSString *)sqlString forClass:(__unsafe_unretained Class<MMPersistable>)clazz
{
    return [_database executeQuery:sqlString forClass:clazz];
}

- (NSUInteger)countOfModelsForClass:(Class<MMPersistable>)clazz withConditions:(NSString *)conditions
{
    return [_database countOfModelsForClass:clazz withConditions:conditions];
}

@end
