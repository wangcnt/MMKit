//
//  NSArrayAdditions.h
//  QTime
//
//  Created by Mark on 15/7/2.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)
- (BOOL)isEmpty;
- (NSMutableArray *)mutableDeepCopy;
@end


@interface NSArray (Numbers)

// Be aware of that 0 will be return if length==0
- (float)maxFloat;
- (float)minFloat;
- (float)floatSum;
- (float)floatAverage;
- (NSInteger)maxInteger;
- (NSInteger)minInteger;
- (NSInteger)integerSum;
- (NSInteger)integerAverage;

@end

@interface NSArray(JSON)
- (NSString *)JSONString;
@end


@interface NSMutableArray (Additions)
- (void)reverseAllObjects;
@end
