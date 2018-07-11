//
//  MMURI.m
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMURI.h"

#import <MMFoundation/NSStringAdditions.h>
#import <MMLog/MMLog.h>

@interface NSURL (URI)
- (BOOL)isValidURI; ///< 至少要保证前两个相同，如com.huawei, com.hermoe，只有一个com相同也认为是非法URI
@end

@implementation NSURL (URI)

- (BOOL)isValidURI {
    NSString *identifier = self.host;
    NSString *appIdentifier = [NSBundle mainBundle].bundleIdentifier;
    NSString *prefix = [identifier commonPrefixWithString:appIdentifier options:NSCaseInsensitiveSearch];
    NSMutableArray *components = [NSMutableArray arrayWithArray:[prefix componentsSeparatedByString:@"."]];
    [components filterUsingPredicate:[NSPredicate predicateWithFormat:@"length>0"]];
    return components.count>1;
}

@end

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
    if(![url isValidURI]) {
        MMLogError(@"Invalid url: %@", url.absoluteString);
        return nil;
    }
    
    if(self = [super init]) {
        _scheme = url.scheme;
        _identifier = url.host;
        NSRange range = [_identifier rangeOfString:@"." options:NSBackwardsSearch];
        if(range.length) {
            _source = [_identifier substringToIndex:range.location];
            if(range.location+range.length < _identifier.length) {
                _target = [_identifier substringFromIndex:range.location+range.length];
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
