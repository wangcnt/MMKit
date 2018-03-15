//
//  MMSessionConfiguration.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/27.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMSessionConfiguration.h"

#import "MMRequestIDGenerator.h"

@implementation MMSessionConfiguration

- (id<MMRequestIDGenerator>)requestIDGenerator {
    if(!_requestIDGenerator) {
        _requestIDGenerator = [[MMDefaultRequestIDGenerator alloc] init];
    }
    return _requestIDGenerator;
}

@synthesize sessionManager = _sessionManager;
@synthesize connectionClass = _connectionClass;
@synthesize task_queue = _task_queue;
@synthesize database_queue = _database_queue;
@synthesize requestIDGenerator = _requestIDGenerator;

@end

@interface MMHTTPSessionConfiguration ()
@property (nonatomic, strong) NSMutableDictionary *headerDictionary;
@end

@implementation MMHTTPSessionConfiguration

@synthesize urlString = _urlString;
@synthesize headerEntries = _headerEntries;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _headerDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setHeaderWithField:(NSString *)field value:(NSString *)value {
    if(field && value) {
        [self setHeaderEntriesWithEntries:@{field : value}];
    }
}

- (void)setHeaderEntriesWithEntries:(NSDictionary *)headerEntries {
    [_headerDictionary addEntriesFromDictionary:headerEntries];
}

- (NSDictionary *)headerEntries {
    return _headerDictionary;
}

@end

@implementation MMSocketSessionConfiguration
@synthesize port = _port;
@synthesize host = _host;
@synthesize usesSSL = _usesSSL;
@end
