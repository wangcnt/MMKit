//
//  MMServiceCenter.h
//  MMArchitecture
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMOperationQueue;

@interface MMServiceCenter : NSObject

// serial queue
@property (nonatomic, strong, readonly) MMOperationQueue *serialQueue;

// concurrent queue
@property (nonatomic, strong, readonly) MMOperationQueue *highQueue;
@property (nonatomic, strong, readonly) MMOperationQueue *defaultQueue;
@property (nonatomic, strong, readonly) MMOperationQueue *backgroundQueue;

@end
