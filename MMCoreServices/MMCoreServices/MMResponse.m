//
//  MMResponse.m
//  MMCoreServices
//
//  Created by Mark on 2018/1/22.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMResponse.h"

@implementation MMResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        _buffer = [NSMutableData data];
    }
    return self;
}

- (BOOL)shouldParse {
    return YES;
}

- (void)receiveData:(NSData *)data {
    [_buffer appendData:data];
}

@synthesize error = _error;
@synthesize request = _request;
@synthesize buffer = _buffer;
@synthesize streamable = _streamable;
@synthesize shouldParse = _shouldParse;

@end

@implementation MMHTTPResponse

@synthesize urlResponse = _urlResponse;

- (void)analyzeURLResponseHeaders {
}

- (instancetype)initWithRequest:(id<MMRequest>)request urlResponse:(NSURLResponse *)urlResponse {
    if(self = [super init]) {
        self.request = request;
        _urlResponse = urlResponse;
        [self analyzeURLResponseHeaders];
    }
    return self;
}

@end

@implementation MMSocketResponse

@synthesize logining = _logining;
@synthesize logined = _logined;

@end

