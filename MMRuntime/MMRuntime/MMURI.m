//
//  MMURI.m
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMURI.h"

#import <MMFoundation/NSStringAdditions.h>

@implementation MMURI

+ (instancetype)URIWithString:(NSString *)URLString {
    return [MMURI URIWithURL:[NSURL URLWithString:URLString]];
}

+ (instancetype)URIWithURL:(NSURL *)url {
    return [[MMURI alloc] initWithURL:url];
}

- (instancetype)initWithString:(NSString *)URLString {
    return [[MMURI alloc] initWithURL:[NSURL URLWithString:URLString]];
}

- (instancetype)initWithURL:(NSURL *)url {
    if(!url) {
        return nil;
    }
    
    if(self = [super init]) {
        _scheme = url.scheme;
        _identifier = url.host;
        if(_identifier) {
            NSRange range = [_identifier rangeOfString:@"." options:NSBackwardsSearch];
            if(range.length) {
                _source = [_identifier substringToIndex:range.location];
                if(range.location+range.length < _identifier.length) {
                    _target = [_identifier substringFromIndex:range.location+range.length];
                }
            }
        }
        
        _action = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        NSString *query = [url.query stringByURLDecoding];
        NSArray *keyValues = [query componentsSeparatedByString:@"&"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:keyValues.count];
        NSArray *temp;
        for(NSString *keyValue in keyValues) {
            temp = [keyValue componentsSeparatedByString:@"="];
            if(temp.count == 2) {
                parameters[temp.firstObject] = temp.lastObject;
            }
        }
        _parameters = [parameters copy];
    }
    return self;
}

- (void)setParameters:(NSDictionary *)parameters {
    if(_parameters != parameters) {
        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:_parameters];
        [temp addEntriesFromDictionary:parameters];
        _parameters = [temp copy];
    }
}

@synthesize scheme = _scheme;
@synthesize identifier = _identifier;
@synthesize source = _source;
@synthesize target = _target;
@synthesize parameters = _parameters;
@synthesize action = _action;

@end
