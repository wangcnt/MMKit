//
//  DPPersonProxy.m
//  MMExamples
//
//  Created by Mark on 2018/2/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "DPPersonProxy.h"

@interface DPPersonProxy() {
@private id<DPPersonProtocol> _person;
}
@end

@implementation DPPersonProxy

- (instancetype)initWithPerson:(id<DPPersonProtocol>)person {
    _person = person;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if(_person) {
        if([_person respondsToSelector:invocation.selector]) {
            NSLog(@"proxy invocation obj method : %@", NSStringFromSelector(invocation.selector));
            invocation.target = _person;
            [invocation invoke];
        } else {
            NSLog(@"%@ doesnot responds to selector: %@", _person, NSStringFromSelector(invocation.selector));
        }
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if([_person isKindOfClass:NSObject.class]) {
        NSMethodSignature *signature = [(NSObject *)_person methodSignatureForSelector:sel];
        return signature;
    }
    
    NSMethodSignature *signature = [super methodSignatureForSelector:sel];
    return signature;
}


//+ (void)goDie {
//    NSLog(@"proxy--->go die");
//}

//- (BOOL)isAGoodGuy {
//    NSLog(@"proxy--->isAGoodGuy");
//    return YES;
//}

- (void)buyFish:(NSString *)fishName withMoney:(float)money {
    NSLog(@"Proxy--->I want to buy a fish %@ with money: %.2f", fishName, money);
}

@end
