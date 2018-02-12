//
//  MMOperationQueue.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/29.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * <font color="red">
 * 1. Only -addOperation: is permitted to add an operation to the queue.<br/>
 * 2. Only the operation conforms to MMOperation can be add into the queue.
 * </font>
 */
@interface MMOperationQueue : NSOperationQueue

@end
