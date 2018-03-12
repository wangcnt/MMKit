//
//  MMSomething.h
//  MMSamples
//
//  Created by Mark on 2018/3/12.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSomething : NSObject

- (void)print;

- (void)fetchSomethingWithIdentifier:(NSString *)identifier completion:(void (^)(MMSomething *sth))completion;

@end
