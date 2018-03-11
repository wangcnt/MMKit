//
//  MMApplication.h
//  MMCoreServices
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMCoreDefines.h"
#import "MMOperationQueue.h"

MMCORESERVICES_EXPORT NSString *const MMCoreServicesErrorDomain;

@interface MMApplication : NSObject

// concurrent queue
@property (nonatomic, strong, readonly) MMOperationQueue *highQueue;
@property (nonatomic, strong, readonly) MMOperationQueue *defaultQueue;
@property (nonatomic, strong, readonly) MMOperationQueue *backgroundQueue;

+ (instancetype)sharedInstance;

@end
