//
//  MMRequest.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/22.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMArchitectureConstants.h"

@protocol MMResponse, MMSessionConfiguration, MMHTTPSessionConfiguration, MMSocketSessionConfiguration;

typedef enum : NSUInteger {
    MMRequestTypeDefault,
    MMRequestTypeLogin,
    MMRequestTypeLogoff,
} MMRequestType;

@protocol MMRequest <NSObject>

@required
@property (nonatomic, strong, readonly) NSData *payload;
@property (nonatomic, strong, readonly) NSString *command;
@property (nonatomic, assign, readonly) Class<MMResponse> responseClass;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign, readonly) MMRequestType type;

@property (nonatomic, strong) id<MMSessionConfiguration> configuration;

@property (nonatomic, strong) NSString *identifier;

@optional

- (void)prepare;

@end

@protocol MMHTTPRequest <NSObject, MMRequest>

@required
@property (nonatomic, strong, readonly) NSString *urlString;
@property (nonatomic, strong, readonly) NSMutableURLRequest *urlRequest;

@optional
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *token;

@end

@protocol MMSocketRequest <NSObject, MMRequest>
@required
@property (nonatomic, strong) NSString *connectionID; ///< MMSocketConnection's identifier. @see MMSocketConnectionType
@optional
@end



@interface MMRequest : NSObject <MMRequest> {
    @protected
    id<MMSessionConfiguration> _configuration;
}

@property (nonatomic, strong, readonly) NSString *command;
@property (nonatomic, assign, readonly) Class<MMResponse> responseClass;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;   ///< default : 60s, minimum : 10s
@property (nonatomic, assign, readonly) MMRequestType type;
@property (nonatomic, strong, readonly) NSData *payload;
@property (nonatomic, strong) id<MMSessionConfiguration> configuration;

@property (nonatomic, strong) NSString *identifier;

- (void)prepare;

@end

@interface MMHTTPRequest : MMRequest <MMHTTPRequest>
@property (nonatomic, strong, readonly) NSString *urlString;
@property (nonatomic, strong, readonly) NSMutableURLRequest *urlRequest;
@end

@interface MMSocketRequest : MMRequest <MMSocketRequest>
@property (nonatomic, strong) NSString *connectionID; ///< MMSocketConnection's identifier. @see MMSocketConnectionType
@end
