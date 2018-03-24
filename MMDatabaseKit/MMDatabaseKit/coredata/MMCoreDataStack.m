//
//  MMCoreDataStack.m
//  MMDatabaseKit
//
//  Created by Mark on 2018/3/24.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMCoreDataStack.h"
#import <CoreData/CoreData.h>
#import <MMLog/MMLog.h>

@interface MMCoreDataStack ()

@end

@implementation MMCoreDataStack

@synthesize coordinator = _coordinator;
@synthesize model = _model;
@synthesize mainContext = _mainContext;
@synthesize backgroundContext = _backgroundContext;
@synthesize storeURL = _storeURL;

+ (instancetype)binaryStackWithName:(NSString *)modelName
{
    return [self stackWithModelName:modelName storeType:NSBinaryStoreType];
}

+ (instancetype)inMemoryStackWithName:(NSString *)modelName
{
    return [self stackWithModelName:modelName storeType:NSInMemoryStoreType];
}

+ (instancetype)sqliteStackWithName:(NSString *)modelName
{
    return [self stackWithModelName:modelName storeType:NSSQLiteStoreType];
}

+ (instancetype)stackWithModelName:(NSString *)modelName storeType:(NSString *)storeType
{
    return [[self alloc] initWithModelName:modelName storeType:storeType];
}

- (instancetype)initWithModelName:(NSString *)modelName storeType:(NSString *)storeType
{
    if (self = [super init]) {
        _modelName = modelName;
        _storeType = storeType;
    }
    return self;
}

#pragma mark - HCDCoreDataStack Protocol

- (NSPersistentStoreCoordinator *)coordinator {
    if (!_coordinator) {
        /* Create PSC */
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption  : @YES,
                                  NSInferMappingModelAutomaticallyOption        : @YES};
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        /* Add store to it */
        NSError *error = nil;
        if (![_coordinator addPersistentStoreWithType:self.storeType configuration:nil URL:self.storeURL options:options error:&error]) {
            MMLogInfo(@"CD Error: %s\n%@\n%@", __PRETTY_FUNCTION__, [self class], error);
        }
    }
    return _coordinator;
}

- (NSManagedObjectModel *)model {
    if (!_model) {
        /* Current model */
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:self.modelName withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    }
    return _model;
}

- (NSManagedObjectContext *)mainContext {
    if (!_mainContext) {
        /* Create background context with attached psc */
        NSManagedObjectContext *rootContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        rootContext.persistentStoreCoordinator = self.coordinator;
        
        /* Create main queue context as main */
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.parentContext = rootContext;
    }
    return _mainContext;
}

- (NSManagedObjectContext *)backgroundContext {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = self.mainContext;
    return context;
}

#pragma mark - Private Accessors

- (NSURL *)storeURL
{
    if (!_storeURL) {
        _storeURL = [self _defaultStoreURL];
    }
    return _storeURL;
}

#pragma mark - Private

- (NSURL *)_defaultStoreURL
{
    NSFileManager *fileManager = [NSFileManager new];
#if TARGET_OS_IPHONE
    NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    return [libraryURL URLByAppendingPathComponent:self.modelName];
#else
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundleIdentifier = [[bundle infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    appSupportURL = [appSupportURL URLByAppendingPathComponent:bundleIdentifier];
    
    /* Check if folder does not exists and create it */
    if (![fileManager fileExistsAtPath:appSupportURL.path]) {
        
        NSError *error = nil;
        [fileManager createDirectoryAtPath:appSupportURL.path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return [appSupportURL URLByAppendingPathComponent:self.modelName];
#endif
}

@end
