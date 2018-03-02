//
//  MMIDGenerator.m
//  MMFoundation
//
//  Created by Mark on 2018/2/26.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMIDGenerator.h"

@interface MMDefaultIDGenerator ()
@property (nonatomic, assign) NSInteger count;
@end

@implementation MMDefaultIDGenerator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)dealloc {
    
}

- (NSString *)nextID {
    NSString *nextID = nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if(_prefix.length) {
        if(![_prefix hasSuffix:@"."]) {
            _prefix = [NSString stringWithFormat:@"%@.", _prefix];
        }
        nextID = [NSString stringWithFormat:@"%@%ld", _prefix, _count];
    } else {
        nextID = [NSString stringWithFormat:@"%ld", _count];
    }
    dispatch_semaphore_signal(_semaphore);
    return nil;
}

@synthesize prefix = _prefix;

@end
