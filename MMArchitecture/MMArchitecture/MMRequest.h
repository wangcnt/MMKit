//
//  MMRequest.h
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/22.
//  Copyright © 2018年 WangQiang. All rights reserved.
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

@optional
@property (nonatomic, strong) NSString *taskIdentifier; ///< MMSocketConnection's identifier. @see MMSocketConnectionType

- (void)prepare;

@end

@protocol MMHTTPRequest <NSObject, MMRequest>

@required
@property (nonatomic, strong, readonly) NSMutableURLRequest *urlRequest;
@property (nonatomic, strong) NSString *urlString;    ///<

@optional
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *token;

@end

@protocol MMSocketRequest <NSObject, MMRequest>
@required
@property (nonatomic, strong) NSString *taskIdentifier; ///< MMSocketConnection's identifier. @see MMSocketConnectionType
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

- (void)prepare;

@end

@interface MMHTTPRequest : MMRequest <MMHTTPRequest>

@property (nonatomic, strong) NSString *urlString;    ///<
@property (nonatomic, strong, readonly) NSMutableURLRequest *urlRequest;

@end

@interface MMSocketRequest : MMRequest <MMSocketRequest>
@property (nonatomic, strong) NSString *identifier;
@end
