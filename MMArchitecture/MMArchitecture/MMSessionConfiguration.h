//
//  MMSessionConfiguration.h
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/27.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMConnection, MMSessionManager;
@class MMSessionManager;

@protocol MMSessionConfiguration <NSObject>
@required
@property (nonatomic, strong) id<MMSessionManager> sessionManager;  ///< The manager that manages a group of similar connections, requests, responses.
@property (nonatomic, strong) Class<MMConnection> connectionClass;  ///< The connection class that could interact with server, caches and saves the requests, then generates response, callbacks to MMOperation.
@optional
@property (nonatomic, strong) dispatch_queue_t task_queue;  ///< The queue that the MMSessionManager runs in, can be serial or concurrent. Default is serial.
@property (nonatomic, strong) dispatch_queue_t database_queue;  ///< The queue that we handle the data received from server. Default is global.
@end

@protocol MMHTTPSessionConfiguration <NSObject, MMSessionConfiguration>
@required
@property (nonatomic, strong) NSString *urlString;
@optional
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *token;
@end

@protocol MMSocketSessionConfiguration <NSObject, MMSessionConfiguration>
@property (nonatomic, strong) NSString *urlString;    ///<
@required

@property (nonatomic, strong) Class<MMConnection> connectionClass;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) int port;

@optional
@property (nonatomic, assign) BOOL usesSSL;

@end


@interface MMSessionConfiguration : NSObject <MMSessionConfiguration>
@property (nonatomic, strong) id<MMSessionManager> sessionManager;
@property (nonatomic, strong) Class<MMConnection> connectionClass;
@property (nonatomic, strong) dispatch_queue_t task_queue;
@property (nonatomic, strong) dispatch_queue_t database_queue;
@end

@interface MMHTTPSessionConfiguration : MMSessionConfiguration <MMHTTPSessionConfiguration>
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *token;
@end

@interface MMSocketSessionConfiguration : MMSessionConfiguration <MMSocketSessionConfiguration>

@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) int port;
@property (nonatomic, assign) BOOL usesSSL;

@end

