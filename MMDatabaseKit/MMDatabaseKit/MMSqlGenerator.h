//
//  MMSqlGenerator.h
//  MMime
//
//  Created by Mark on 15/6/9.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMDatabase.h"

typedef enum
{
    MMDatabaseOperationTypeUpdate,
    MMDatabaseOperationTypeDelete
}MMDatabaseOperationType;   // 查询的sql比较复杂，所以暂不支持

typedef enum
{
    MMSqlGeneratorTypeCommon,
    MMSqlGeneratorTypeDictionary
}MMSqlGeneratorType;

@interface MMSqlGenerator : NSObject

+ (instancetype)defaultGenerator;

- (Class)getClassForModel:(id<MMPersistable>)model;

- (NSString *)generateInsertSqlWithModel:(id<MMPersistable>)model columns:(NSArray *)columns;

- (NSArray *)generateInsertArgumentsWithModel:(id<MMPersistable>)model columns:(NSArray *)columns;

- (NSString *)generateUpdateSqlWithModel:(id<MMPersistable>)model operationType:(MMDatabaseOperationType)type;

- (NSString *)generateQuerySqlWithParameters:(NSDictionary *)parameters forClass:(__unsafe_unretained Class<MMPersistable>)clazz;

- (NSString *)generateQuerySqlWithConditions:(NSString *)conditions forClass:(__unsafe_unretained Class<MMPersistable>)clazz;

@end
