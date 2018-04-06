//
//  MMPersistable.h
//  MMDatabaseKit
//
//  Created by Mark on 15/6/30.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#ifndef MMDatabaseKit_MMPersistable_h
#define MMDatabaseKit_MMPersistable_h



#endif


@protocol MMPersistable

@required
+ (NSString *)tableName;
+ (NSString *)creationSql;
+ (NSArray *)upgradeSqls;

+ (id<MMPersistable>)modelWithDatabaseDictionary:(NSDictionary *)dic;

- (NSMutableDictionary *)toDatabaseDictionary;

@property (nonatomic, strong) NSString              *modelId;



@optional
+ (NSArray<NSString *> *)unpersistableProperties;

@end
