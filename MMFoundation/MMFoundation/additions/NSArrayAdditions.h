//
//  NSArrayAdditions.h
//  QTime
//
//  Created by Mark on 15/7/2.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(Additions)
- (NSMutableArray *)mutableDeepCopy;
@end


@interface NSArray(JSON)
- (NSString *)JSONString;
@end


@interface NSMutableArray(Additions)
- (void)reverseAllObjects;
@end
