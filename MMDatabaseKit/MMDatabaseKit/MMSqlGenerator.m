//
//  MMSqlGenerator.m
//  MMime
//
//  Created by Mark on 15/6/9.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMSqlGenerator.h"

@implementation MMSqlGenerator

+ (instancetype)defaultGenerator
{
    static MMSqlGenerator *generator;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        generator = [[MMSqlGenerator alloc] init];
    });
    
    return generator;
}

- (Class)getClassForModel:(id<MMPersistable>)model
{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(model)];
    
    return NSClassFromString(className);
}

- (NSArray *)generateInsertArgumentsWithModel:(id<MMPersistable>)model columns:(NSArray *)columns
{
    NSDictionary *dic = [model toDatabaseDictionary];
   
    NSMutableArray *arguments = [NSMutableArray array];
    
    [columns enumerateObjectsUsingBlock:^(NSString *column, NSUInteger idx, BOOL *stop) {
    
        [arguments addObject:dic[column]];
    }];
    
    return arguments;
}

- (NSString *)generateInsertSqlWithModel:(id<MMPersistable>)model columns:(NSArray *)columns
{
    Class clazz = [self getClassForModel:model];
    NSString *tableName = [clazz tableName];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    [result appendFormat:@"INSERT INTO %@ (", tableName];
    
    [result appendFormat:@"%@) VALUES (", [columns componentsJoinedByString:@", "]];
    
#if DEBUG
    
    NSMutableString *__nothing = [[NSMutableString alloc] initWithString:result];
    
    NSDictionary *dic = [model toDatabaseDictionary];
#endif
    
    
    [columns enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {

        [result appendFormat:@"?"];
        
#if DEBUG
        
        id value = dic[key];
        if([value isKindOfClass:[NSString class]])
        {
            [__nothing appendFormat:@"'%@'", value];
        }
        else if([value isKindOfClass:[NSNumber class]])
        {
            [__nothing appendFormat:@"%f", [value doubleValue]];
        }
        else if([value isKindOfClass:[NSNull class]])
        {
            [__nothing appendFormat:@"NULL"];
        }
#endif
        
        if(idx+1 < columns.count)
        {
            [result appendString:@", "];
            
#if DEBUG
            
            [__nothing appendString:@", "];
#endif
        }
    }];
    
    [result appendFormat:@")"];
    
#if DEBUG
    
    [__nothing appendFormat:@")"];
    
    NSLog(@"insert~~~~~%@", __nothing);
#endif
    
    return result;
}

- (NSString *)generateUpdateSqlWithModel:(id<MMPersistable>)model operationType:(MMDatabaseOperationType)type
{
    Class clazz = [self getClassForModel:model];
    
    NSString *tableName = [clazz tableName];
    
    NSMutableDictionary *dic = [model toDatabaseDictionary];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    switch (type)
    {
        case MMDatabaseOperationTypeDelete  :
        {
            [result appendFormat:@"DELETE FROM %@ WHERE modelId = '%@'", tableName, [model modelId]];
            
            break;
        }
        case MMDatabaseOperationTypeUpdate  :
        {
            [result appendFormat:@"UPDATE %@ SET ", tableName];
            
#if DEBUG
            NSMutableString *__nothing = [[NSMutableString alloc] initWithString:result];
#endif
            [dic.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                
                [result appendFormat:@"%@ = :%@", key, key];
                
#if DEBUG
                
                id value = dic[key];
                if([value isKindOfClass:[NSString class]])
                {
                    [__nothing appendFormat:@"%@ = '%@'", key, value];
                }
                else if([value isKindOfClass:[NSNumber class]])
                {
                    [__nothing appendFormat:@"%@ = %ld", key, [value longValue]];
                }
                else if([value isKindOfClass:[NSNull class]])
                {
                    [__nothing appendFormat:@"%@ = NULL", key];
                }
#endif
                
                if(idx+1 < dic.allKeys.count)
                {
                    [result appendString:@", "];
                    
#if DEBUG
                    [__nothing appendString:@", "];
#endif
                }
            }];
            
            [result appendFormat:@" WHERE modelId = '%@'", [model modelId]];
            
#if DEBUG
            [__nothing appendFormat:@" WHERE modelId = '%@'", [model modelId]];
            
            NSLog(@"update~~~~~%@", __nothing);
#endif
            break;
        }
    }
    
    return result;
}

- (NSString *)generateQuerySqlWithParameters:(NSDictionary *)parameters forClass:(__unsafe_unretained Class<MMPersistable>)clazz
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"SELECT * FROM %@ WHERE ", [clazz tableName]];
    
    [parameters.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        
        id value = parameters[key];
        
        if([value isKindOfClass:[NSNumber class]])
        {
            [result appendFormat:@"%@ = %f", key, [value doubleValue]];
        }
        else if([value isKindOfClass:[NSString class]])
        {
            [result appendFormat:@"%@ = '%@'", key, value];
        }
        
        if(idx+1 < parameters.allKeys.count)
        {
            [result appendString:@" AND "];
        }
    }];
    
    NSLog(@".....fmdb.query....[%@]", result);
    
    return result;
}

- (NSString *)generateQuerySqlWithConditions:(NSString *)conditions forClass:(__unsafe_unretained Class<MMPersistable>)clazz
{
    conditions = [conditions stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(   [conditions rangeOfString:@"ORDER " options:NSCaseInsensitiveSearch].location == 0
       || [conditions rangeOfString:@"GROUP " options:NSCaseInsensitiveSearch].location == 0)
    {
        conditions = [NSString stringWithFormat:@"1=1 %@", conditions];
    }
    
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT * FROM %@ WHERE %@", [clazz tableName], conditions];
    
    NSLog(@".....fmdb.query....[%@]", sql);
    
    return sql;
}

@end
