//
//  DPPerson.m
//  MMExamples
//
//  Created by WangQiang on 2018/2/2.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "DPPerson.h"

@implementation DPPerson

//+ (void)goDie {
//    NSLog(@"go die");
//}

- (void)eat {
    NSLog(@"eat");
}

- (BOOL)isAGoodGuy {
    return YES;
}

- (void)buyFish:(NSString *)fishName withMoney:(float)money {
    NSLog(@"I want to buy a fish %@ with money: %.2f", fishName, money);
}

- (void)bathWithCompletion:(void (^)(BOOL successed))completion {
    if(completion) {
        completion(YES);
    }
}

@end
