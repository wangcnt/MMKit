//
//  MMRequest.m
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/22.
//  Copyright © 2018年 WangQiang. All rights reserved.
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

- (void)setConfiguration:(id<MMSessionConfiguration>)configuration {
    if(![configuration conformsToProtocol:@protocol(MMHTTPSessionConfiguration)]){
        return;
    }
    super.configuration = configuration;
}

- (NSString *)urlString {
    NSString *urlString = nil;
    id<MMHTTPSessionConfiguration> configuration = (id<MMHTTPSessionConfiguration>)self.configuration;
    if(configuration) {
        urlString = configuration.urlString;
    }
    return urlString;
}

- (NSString *)userAgent {
    NSString *userAgent = nil;
    id<MMHTTPSessionConfiguration> configuration = (id<MMHTTPSessionConfiguration>)self.configuration;
    if(configuration) {
        userAgent = configuration.userAgent;
    }
    return userAgent;
}

- (NSString *)token {
    NSString *token = nil;
    id<MMHTTPSessionConfiguration> configuration = (id<MMHTTPSessionConfiguration>)self.configuration;
    if(configuration) {
        token = configuration.token;
    }
    return token;
}

- (void)prepare {
    if(!_configuration || ![_configuration conformsToProtocol:@protocol(MMHTTPSessionConfiguration)]) {
        _configuration = [[MMHTTPSessionConfiguration alloc] init];
    }
    self.urlRequest.timeoutInterval = MAX(self.timeoutInterval, 10);
    NSString *userAgent = [self userAgent];
    if(userAgent) {
        [self.urlRequest addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    NSString *token = [self token];
    if(token) {
        [self.urlRequest addValue:token forHTTPHeaderField:@"token"];
    }
    NSData *payload = self.payload;
    if(payload.length) {
        self.urlRequest.HTTPBody = self.payload;
    }
}

@end

@implementation MMSocketRequest

@end
