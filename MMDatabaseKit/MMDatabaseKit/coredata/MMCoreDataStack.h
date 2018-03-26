//
//  MMCoreDataStack.h
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/24.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMCoreDataStackProtocol <NSObject>

@required
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *coordinator;  ///< Current store coordinator
@property (nonatomic, strong, readonly) NSManagedObjectModel *model;    ///< Current object model
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;    ///< Your single source of truth. Associated with main queue.
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;  ///< Each invocation will generate a new context that uses main context as parent context.
@property (nonatomic, strong) NSURL *storeURL;  ///< The local url where the store is placed

@end

@interface MMCoreDataStack : NSObject <MMCoreDataStackProtocol>

// modelName: @see NSStoreTypeKey
+ (instancetype)binaryStackWithName:(NSString *)modelName;
+ (instancetype)inMemoryStackWithName:(NSString *)modelName;
+ (instancetype)sqliteStackWithName:(NSString *)modelName;

+ (instancetype)stackWithModelName:(NSString *)modelName storeType:(NSString *)storeType;
- (instancetype)initWithModelName:(NSString *)modelName storeType:(NSString *)storeType NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, copy, readonly) NSString *modelName;  ///< Current model name
@property (nonatomic, copy, readonly) NSString *storeType;  ///< Current store type

@end
