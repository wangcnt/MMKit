//
//  MMAccessor.h
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMURI;

extern NSString * const MMRuntimeErrorDomain;

typedef NS_ENUM(NSInteger, MMRuntimeErrorCode) {
    MMRuntimeErrorCodeUnknown,
    MMRuntimeErrorCodeBundleNotInstalled,
    MMRuntimeErrorCodeResourceNotReachable,
    MMRuntimeErrorCodeNotImplemented
};

@interface MMAccessor : NSObject

+ (instancetype)sharedInstance;

- (id)resourceWithURI:(MMURI *)uri;

@end
