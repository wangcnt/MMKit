//
//  MMConnection.h
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/23.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMArchitectureConstants.h"

FOUNDATION_EXPORT NSString *const MMSocketConnectionDefaultIdentifier;
FOUNDATION_EXPORT NSString *const MMSocketConnectionFreeIdentifier;

@protocol MMRequest, MMSocketSessionManager, MMSocketRequest;

typedef enum : NSUInteger {
    MMSocketConnectionTypeDefault,  ///< Any task, needs login manually.
    MMSocketConnectionTypeFree,     ///< Needs not to login.
    MMSocketConnectionTypeGroup    ///< A group of tasks that will be executed in an alone connection, needs login automatically.
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
@end

@protocol MMHTTPConnection <NSObject, MMConnection>
@end

@protocol MMSocketConnection <NSObject, MMConnection>

@required
@property (nonatomic, strong, readonly) NSMutableData *buffer;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) int port;
@property (nonatomic, assign, readonly) MMSocketConnectionType type;
@property (nonatomic, strong) NSString *identifier;     ///< Each connection will have its own distinct identifier, and there must be a default connection with the unique identifier "Default"
@property (nonatomic, assign) MMConnectionStatus status;
@property (nonatomic, assign) MMSocketConnectionLoginStatus loginStatus;

@property (nonatomic, assign) NSTimeInterval pingInterval;

@property (nonatomic, strong) dispatch_queue_t completion_queue;
@property (nonatomic, weak) id<MMSocketSessionManager> manager;

@required
- (void)connect;
- (void)disconnect;

@optional
- (void)sendRequest:(id<MMRequest>)request withCompletion:(MMRequestCompletion)completion;

- (void)cancelRequest:(id<MMRequest>)request;
- (void)cancelRequests:(NSArray<id<MMRequest>> *)requests;
- (void)cancelAllRequests;

@end



@interface MMConnection : NSObject
@end

@interface MMHTTPConnection : MMConnection <MMHTTPConnection>
@end

@interface MMSocketConnection : MMConnection <MMSocketConnection>

@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) int port;
@property (nonatomic, assign, readonly) MMSocketConnectionType type;
@property (nonatomic, strong) NSString *identifier;     ///< Every connection will have its own distinct identifier, and there must be a default connection with the unique identifier "Default"
@property (nonatomic, assign) MMConnectionStatus status;
@property (nonatomic, assign) MMSocketConnectionLoginStatus loginStatus;

@property (nonatomic, assign) NSTimeInterval pingInterval;

@property (nonatomic, strong) dispatch_queue_t completion_queue;
@property (nonatomic, weak) id<MMSocketSessionManager> manager;

@property (nonatomic, strong, readonly) NSMutableData *buffer;

- (void)connect;
- (void)disconnect;

- (void)sendRequest:(id<MMSocketRequest>)request withCompletion:(MMRequestCompletion)completion;

- (void)cancelRequest:(id<MMSocketRequest>)request;
- (void)cancelRequests:(NSArray<id<MMSocketRequest>> *)requests;
- (void)cancelAllRequests;

@end

