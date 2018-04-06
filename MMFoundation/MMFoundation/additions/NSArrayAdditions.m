//
//  NSArrayAdditions.m
//  QTime
//
//  Created by Mark on 15/7/2.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "NSDictionaryAdditions.h"
#import "NSDataAdditions.h"
#import "MMDefines.h"

__mm_synth_dummy_class__(NSArrayAdditions)

@implementation NSArray (Additions)

- (BOOL)isEmpty {
    return [self isKindOfClass:NSNull.class] || !self.count;
}

- (NSObject *)anyObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
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

@implementation NSArray (Plist)

+ (NSArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

+ (NSArray *)arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (NSData *)plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.UTF8String;
    return nil;
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

+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (NSMutableArray *)arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (void)removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)appendObject:(id)anObject {
    [self addObject:anObject];
}

- (void)prependObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

- (void)appendObjects:(NSArray *)objects {
    if (!objects) return;
    [self addObjectsFromArray:objects];
}

- (void)prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1) withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
