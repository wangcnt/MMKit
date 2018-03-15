//
//  MMSessionConfiguration.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/27.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMConnection, MMSessionManager, MMRequestIDGenerator;
@class MMSessionManager;

@protocol MMSessionConfiguration <NSObject>
@required
@property (nonatomic, strong) id<MMSessionManager> sessionManager;  ///< The manager that manages a group of similar connections, requests, responses.
@property (nonatomic, strong) Class<MMConnection> connectionClass;  ///< The connection class that could interact with server, caches and saves the requests, then generates response, callbacks to MMOperation.  It will be created automatically by request type.
@optional
@property (nonatomic, strong) dispatch_queue_t task_queue;  ///< The queue that the MMSessionManager runs in, can be serial or concurrent. Default is serial.
@property (nonatomic, strong) dispatch_queue_t database_queue;  ///< The queue that we handle the data received from server. Default is global.
@property (nonatomic, strong) id<MMRequestIDGenerator> requestIDGenerator; ///< Maybe each request will have an identifier
@end

@protocol MMHTTPSessionConfiguration <MMSessionConfiguration>
@required
@property (nonatomic, strong) NSString *urlString;
@optional
@property (nonatomic, strong, readonly) NSDictionary *headerEntries;
- (void)setHeaderWithField:(NSString *)field value:(NSString *)value;
- (void)setHeaderEntriesWithEntries:(NSDictionary *)headerEntries;
@end

@protocol MMSocketSessionConfiguration <MMSessionConfiguration>
@required
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) int port;
@optional
@property (nonatomic, assign) BOOL usesSSL;
@end


@interface MMSessionConfiguration : NSObject <MMSessionConfiguration> {
    id<MMRequestIDGenerator> _requestIDGenerator;
}
@end

@interface MMHTTPSessionConfiguration : MMSessionConfiguration <MMHTTPSessionConfiguration>
@end

@interface MMSocketSessionConfiguration : MMSessionConfiguration <MMSocketSessionConfiguration>
@end

