//
//  MMServiceCenter.h
//  MMCoreServices
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMFoundation/MMProxy.h>
#import "MMService.h"

@class MMOperationQueue, MMService;

/*!
 * Warning: DO NOT implement the unimplemented method, or the task won't be
 * dispatched to the target 'MMService's.
 */
@interface MMServiceCenter : MMProxy <MMService>

// serial queue
@property (nonatomic, strong, readonly) MMOperationQueue *serialQueue;  ///> 不應該提供，多插件的話可能阻塞，應該單插件化

- (void)registerService:(id<MMService>)service; ///< MUST: service.serviceID
- (void)unregisterService:(id<MMService>)service; ///< MUST: service.serviceID

- (id<MMService>)serviceForServiceID:(id<MMServiceID>)serviceID;

- (void)startService:(id<MMService>)service; ///< Different from -startService that starts all registerred services, it starts only a service.
- (void)stopService:(id<MMService>)service withCompletion:(void (^)(NSError *error))completion; ///< Different from -stopService that stops all single-scoped services, it stops only a single-scoped service.

@end
