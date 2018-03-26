//
//  MMResponse.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/22.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMCoreDefines.h"
#import "MMRequest.h"

@protocol MMResponse <NSObject>

@required
@property (nonatomic, strong, readonly) NSMutableData *buffer;
@property (nonatomic, strong) id<MMRequest> request;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL streamable;  ///< Parse during receiving data from server
@property (nonatomic, assign, readonly) BOOL shouldParse;

@required
- (void)receiveData:(NSData *)data;

@end

@protocol MMHTTPResponse <MMResponse>

@required
@property (nonatomic, strong, readonly) NSURLResponse *urlResponse;

@required
- (instancetype)initWithRequest:(id<MMRequest>)request urlResponse:(NSURLResponse *)urlResponse;
- (void)analyzeURLResponseHeaders;

@end

@protocol MMSocketResponse <MMResponse>
@required
@property (nonatomic, assign) BOOL logined;
@property (nonatomic, assign) BOOL logining;
@end

@interface MMResponse : NSObject <MMResponse>
@end

@interface MMHTTPResponse : MMResponse <MMHTTPResponse>
@end

@interface MMSocketResponse : MMResponse <MMSocketResponse>
@end


