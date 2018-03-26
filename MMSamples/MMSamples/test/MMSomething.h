//
//  MMSomething.h
//  MMSamples
//
//  Created by Mark on 2018/3/12.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol A <NSObject>
@end

@protocol B <A>
@property (nonatomic, strong) NSString *ha;
@end

@interface A : NSObject <A> {
}
@end

@interface B : A <B>
@end



@interface MMSomething : NSObject

@property (nonatomic, strong) id<A> a;
@property (nonatomic, strong) NSString *name;

- (void)print;

- (void)fetchSomethingWithIdentifier:(NSString *)identifier completion:(void (^)(MMSomething *sth))completion;

@end

@interface MMSubthing : MMSomething
@property (nonatomic, strong) id<B> a;
@end

