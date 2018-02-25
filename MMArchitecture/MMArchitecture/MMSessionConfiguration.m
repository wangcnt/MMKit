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

@end

@implementation MMHTTPSessionConfiguration

@end

@implementation MMSocketSessionConfiguration

@end
