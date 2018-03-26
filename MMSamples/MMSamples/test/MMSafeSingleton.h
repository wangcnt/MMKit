//
//  MMSafeSingleton.h
//  MMSamples
//
//  Created by Mark on 2018/3/10.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSafeSingleton : NSObject

@property (nonatomic, strong) NSString *name;

+ (instancetype)sharedInstance;

@end
