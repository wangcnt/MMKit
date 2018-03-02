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

@implementation MMHTTPSessionConfiguration
@synthesize urlString = _urlString;
@synthesize token = _token;
@synthesize userAgent = _userAgent;
@end

@implementation MMSocketSessionConfiguration
@synthesize port = _port;
@synthesize host = _host;
@synthesize usesSSL = _usesSSL;
@end
