//
//  MMURI.h
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMURI : NSObject

@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *target;
@property (nonatomic, copy, readonly) NSString *action;

@property (nonatomic, retain) NSDictionary *parameters; ///< 会覆盖掉初始化时与此参数集重复的key的值

+ (instancetype)URIWithString:(NSString *)URIString;
+ (instancetype)URIWithURL:(NSURL *)url;
- (instancetype)initWithString:(NSString *)URIString;
- (instancetype)initWithURL:(NSURL *)url;

@end
