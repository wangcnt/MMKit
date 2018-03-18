//
//  MMRequest.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/22.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMRequest.h"

#import "MMSessionConfiguration.h"

@implementation MMRequest

@synthesize configuration = _configuration;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeoutInterval = 60;
    }
    return self;
}

- (void)prepare {
}

- (NSString *)debugDescription {
    return [[NSString alloc] initWithData:self.payload encoding:NSUTF8StringEncoding];
}

@synthesize identifier = _identifier;
@synthesize responseClass = _responseClass;
@synthesize payload = _payload;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize command = _command;
@synthesize type = _type;
@synthesize stepHandler = _stepHandler;

@synthesize progressHandler = _progressHandler;

@synthesize serviceID = _serviceID;

@end

@implementation MMHTTPRequest

@synthesize urlRequest = _urlRequest;

- (NSMutableURLRequest *)urlRequest {
    id<MMHTTPSessionConfiguration> configuration = (id<MMHTTPSessionConfiguration>)self.configuration;
    if(!configuration.urlString.length) return nil;
    if(!_urlRequest) {
        _urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:configuration.urlString]];
    }
    return _urlRequest;
}

- (NSString *)urlString {
    NSString *urlString = nil;
    id<MMHTTPSessionConfiguration> configuration = (id<MMHTTPSessionConfiguration>)self.configuration;
    if(configuration) {
        urlString = configuration.urlString;
    }
    return urlString;
}

- (void)prepare {
    self.urlRequest.timeoutInterval = MAX(self.timeoutInterval, 10);
    
    id<MMHTTPSessionConfiguration> configuration = (id<MMHTTPSessionConfiguration>)self.configuration;
    [configuration.headerEntries enumerateKeysAndObjectsUsingBlock:^(NSString *field, NSString *value, BOOL *stop) {
        [self.urlRequest setValue:value forHTTPHeaderField:field];
    }];
    
    NSData *payload = self.payload;
    if(payload.length) {
        self.urlRequest.HTTPBody = self.payload;
    }
}

@end

@implementation MMSocketRequest
@synthesize connectionID = _connectionID;
@end
