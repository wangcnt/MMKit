//
//  MMConnection.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/23.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMCoreDefines.h"

typedef NSString *MMSocketConnectionIdentifier NS_EXTENSIBLE_STRING_ENUM;
MMCORESERVICES_EXPORT MMSocketConnectionIdentifier const MMSocketConnectionDefaultIdentifier;
MMCORESERVICES_EXPORT MMSocketConnectionIdentifier const MMSocketConnectionFreeIdentifier;

@protocol MMRequest, MMSocketSessionManager, MMSocketRequest;

typedef enum : NSUInteger {
    MMSocketConnectionTypeDefault,  ///< Any task, needs login manually.
    MMSocketConnectionTypeFree,     ///< Needs not to login.
    MMSocketConnectionTypeGroup     ///< A group of tasks that will be executed in an alone connection, needs login manually
} MMSocketConnectionType;

typedef enum : NSUInteger {
    MMConnectionStatusOffworked,
    MMConnectionStatusBusy
} MMConnectionStatus;

typedef enum : NSUInteger {
    MMSocketConnectionLoginStatusTraveller,
    MMSocketConnectionLoginStatusLogining,
    MMSocketConnectionLoginStatusLogined,
} MMSocketConnectionLoginStatus;

@protocol MMConnection <NSObject>

- (void)sendRequest:(id<MMRequest>)request withCompletion:(MMRequestCompletion)completion;

- (void)cancelRequest:(id<MMRequest>)request withError:(NSError *)error;
- (void)cancelAllRequestsWithError:(NSError *)error;

@end

@protocol MMHTTPConnection <MMConnection>
@end

@protocol MMSocketConnection <MMConnection>

@required
@property (nonatomic, strong, readonly) NSMutableData *buffer;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) int port;
@property (nonatomic, assign, readonly) MMSocketConnectionType type;
@property (nonatomic, strong) NSString *identifier;     ///< Each connection will have its own distinct identifier, and there must be a default connection with the unique identifier "Default"
@property (nonatomic, assign) MMConnectionStatus status;
@property (nonatomic, assign) MMSocketConnectionLoginStatus loginStatus;

@property (nonatomic, assign) NSTimeInterval pingInterval;
@property (nonatomic, weak) id<MMSocketSessionManager> manager;

@required
- (void)connect;
- (void)disconnect;

@end

@interface MMConnection : NSObject <MMConnection>
@end

@interface MMHTTPConnection : MMConnection <MMHTTPConnection>
@end

@interface MMSocketConnection : MMConnection <MMSocketConnection>
@end

