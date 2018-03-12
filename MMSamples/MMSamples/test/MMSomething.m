//
//  MMSomething.m
//  MMSamples
//
//  Created by Mark on 2018/3/12.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMSomething.h"

@implementation MMSomething

- (void)print {
    NSLog(@"I will be print.");
}

- (void)fetchSomethingWithIdentifier:(NSString *)identifier completion:(void (^)(MMSomething *sth))completion {
    if(completion) {
        completion(self);
    }
}

@end
