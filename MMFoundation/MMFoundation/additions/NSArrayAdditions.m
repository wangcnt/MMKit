//
//  NSArrayAdditions.m
//  QTime
//
//  Created by Mark on 15/7/2.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "NSDictionaryAdditions.h"

@implementation NSArray (Additions)

- (BOOL)isEmpty {
    return [self isKindOfClass:NSNull.class] || !self.count;
}

- (NSMutableArray *)mutableDeepCopy {
    NSMutableArray *result = [NSMutableArray array];
    for(int i=0; i<self.count; i++) {
        NSObject *object = self[i];
        if([object respondsToSelector:@selector(mutableDeepCopy)]) {
            id copied = [object performSelector:@selector(mutableDeepCopy)];
            [result addObject:copied];
        } else if([object respondsToSelector:@selector(mutableCopyWithZone:)]) {
            id copied = [object mutableCopy];
            [result addObject:copied];
        } else if([object respondsToSelector:@selector(copy)]) {
            id copied = [object copy];
            [result addObject:copied];
        } else {
            [result addObject:object];
        }
    }
    return result;
}

@end


@implementation NSArray (Numbers)

- (float)maxFloat {
    float max = 0;
    max =[[self valueForKeyPath:@"@max.floatValue"] floatValue];
    return max;
}

- (float)minFloat {
    float min = 0;
    min =[[self valueForKeyPath:@"@min.floatValue"] floatValue];
    return min;
}

- (float)floatSum {
    float sum = 0;
    sum = [[self valueForKeyPath:@"@sum.floatValue"] floatValue];
    return sum;
}

- (float)floatAverage {
    float avg = 0;
    avg = [[self valueForKeyPath:@"@avg.floatValue"] floatValue];
    return avg;
}

- (NSInteger)maxInteger {
    NSInteger max = 0;
    max = [[self valueForKeyPath:@"@max.floatValue"] integerValue];
    return max;
}

- (NSInteger)minInteger {
    NSInteger min = 0;
    min = [[self valueForKeyPath:@"@min.floatValue"] integerValue];
    return min;
}

- (NSInteger)integerSum {
    NSInteger sum = 0;
    sum = [[self valueForKeyPath:@"@sum.floatValue"] integerValue];
    return sum;
}

- (NSInteger)integerAverage {
    NSInteger avg = 0;
    avg = [[self valueForKeyPath:@"@avg.floatValue"] integerValue];
    return avg;
}

@end

@implementation NSArray (JSON)

- (NSString *)JSONString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) {
            return json;
        }
    }
    return nil;
}

@end

@implementation NSMutableArray (Additions)

- (void)reverseAllObjects {
    NSInteger count = self.count;
    if(count > 1) {
        for(int i=0; i<count/2; i++) {
            [self exchangeObjectAtIndex:i withObjectAtIndex:count - i - 1];
        }
    }
}

@end
