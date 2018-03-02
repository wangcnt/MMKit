//
//  MMIDGenerator.h
//  MMFoundation
//
//  Created by Mark on 2018/2/26.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMIDGenerator <NSObject>

@optional
@property (nonatomic, strong) NSString *prefix;

@required
- (NSString *)nextID;   ///< Format: prefix.1/2/3/4/5...  & it's better that using semaphore to make thread safe when overriding.

@end

@interface MMDefaultIDGenerator : NSObject <MMIDGenerator>
@property (nonatomic, strong) dispatch_semaphore_t semaphore;   ///< Default value = 1.
@end
