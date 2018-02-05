//
//  MMResponse.h
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/22.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMArchitectureConstants.h"
#import "MMRequest.h"

@protocol MMResponse <NSObject>

@required
@property (nonatomic, strong, readonly) NSMutableData *buffer;
@property (nonatomic, strong) id<MMRequest> request;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL streamable;  ///< parse during receiving data from server
@property (nonatomic, assign, readonly) BOOL shouldParse;

@required
- (void)receiveData:(NSData *)data;

@end

@protocol MMHTTPResponse <NSObject, MMResponse>

@required
@property (nonatomic, strong, readonly) NSURLResponse *urlResponse;

@required
- (instancetype)initWithRequest:(id<MMRequest>)request urlResponse:(NSURLResponse *)urlResponse;
- (void)analyzeURLResponseHeaders;

@end

@protocol MMSocketResponse <NSObject, MMResponse>
@required
@property (nonatomic, assign) BOOL logined;
@property (nonatomic, assign) BOOL logining;
@end

@interface MMResponse : NSObject <MMResponse>

@property (nonatomic, strong, readonly) NSMutableData *buffer;
@property (nonatomic, strong) id<MMRequest> request;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL streamable;  ///< parse during receiving data from server
@property (nonatomic, assign, readonly) BOOL shouldParse;

- (void)receiveData:(NSData *)data;

@end

@interface MMHTTPResponse : MMResponse <MMHTTPResponse>

- (instancetype)initWithRequest:(id<MMRequest>)request urlResponse:(NSURLResponse *)urlResponse;
- (void)analyzeURLResponseHeaders;

@end

@interface MMSocketResponse : MMResponse <MMSocketResponse>
@property (nonatomic, assign) BOOL logined;
@property (nonatomic, assign) BOOL logining;
@end


