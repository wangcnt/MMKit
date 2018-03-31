//
//  MMChain.h
//  MMSamples
//
//  Created by Mark on 2018/3/25.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMChain : NSObject

@property (nonatomic, strong, readonly, class) MMChain *sharedInstance;

@property (nonatomic, strong, readonly) MMChain * (^addString)(NSString *string);
@property (nonatomic, strong, readonly) MMChain * (^addInteger)(int intValue);
@property (nonatomic, strong, readonly) MMChain * (^print)(void);

@property (nonatomic, strong, readonly) NSString *defaultValue;

@end
