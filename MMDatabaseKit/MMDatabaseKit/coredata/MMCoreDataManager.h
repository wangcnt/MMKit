//
//  MMCoreDataManager.h
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/31.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMCoreDataStore.h"

@interface MMCoreDataManager : NSObject

@property (nonatomic, strong) MMCoreDataStore *defaultStore;    // NSSQLiteStoreType

@end
