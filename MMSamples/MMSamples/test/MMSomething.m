//
//  MMSomething.m
//  MMSamples
//
//  Created by Mark on 2018/3/12.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMSomething.h"

@implementation A
@end

@implementation B
@synthesize ha = _ha;
@end


@interface MMSomething () {
    
}
@end

@implementation MMSomething

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)print {
    NSLog(@"I will be print.");
}

- (void)fetchSomethingWithIdentifier:(NSString *)identifier completion:(void (^)(MMSomething *sth))completion {
    if(completion) {
        completion(self);
    }
}

@end

@interface MMSubthing () {
    id<B> _a;
}

@property (nonatomic, strong) NSMutableArray *things;

@end

@implementation MMSubthing

- (instancetype)init
{
    self = [super init];
    if (self) {
        _things = [NSMutableArray array];
    }
    return self;
}

- (id<B>)a {
    return _a;
}

- (void)setA:(id<A>)a {
    [super setA:a];
}

- (void)print {
    NSLog(@"I will be print b: %@", self.a.ha);
}

@end
