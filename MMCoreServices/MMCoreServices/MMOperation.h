//
//  MMOperation.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/22.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMCoreDefines.h"

@protocol MMRequest, MMSocketRequest, MMResponse, MMSessionManager, MMConnection, MMSessionConfiguration;

@protocol MMOperation <NSObject>

@property (nonatomic, strong) id<MMSessionConfiguration> configuration;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong, readonly) id<MMRequest> request;  ///< Must be override by suboperation.
@property (nonatomic, strong, readonly) id<MMSessionManager> sessionManager;  ///< Must be override by suboperation, request won't be sent if nil.
@property (nonatomic, strong, readonly) id<MMResponse> response;   ///< Generated by connection.
@property (nonatomic, assign) NSTimeInterval timeoutInterval;   ///< default = 60s

@property (nonatomic, assign, readonly) double consumedTimestamp;

@property (nonatomic, assign) NSInteger maxRetryTimes;
@property (nonatomic, assign) NSInteger retryedTimes;

@property (nonatomic, strong) MMRequestStepHandler step;

- (void)presendRequest;
- (BOOL)shouldRetry;
- (void)loadFinished;

@end

@protocol MMHTTPOperation <MMOperation>
@end

@protocol MMSocketOperation <MMOperation>
@required
@property (nonatomic, strong) NSString *connectionID; ///< MMSocketConnection's identifier. @see MMSocketConnectionType
@end


@interface MMOperation : NSOperation <MMOperation> {
    id<MMRequest> _request;
}
@end

@interface MMHTTPOperation : MMOperation <MMHTTPOperation>
@end

@interface MMSocketOperation : MMOperation <MMSocketOperation>
@end
