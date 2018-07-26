//
//  MMAccessor.m
//  MMRuntime
//
//  Created by Mark on 2018/7/6.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMAccessor.h"

#import <MMFoundation/MMDefines.h>
#import "MMURI.h"
#import "MMBundleDelegate.h"
#import "MMBundleProvider.h"
#import <MMLog/MMLog.h>

NSString * const MMRuntimeErrorDomain = @"com.markwong.mmruntime.error";

@interface MMAccessor ()
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;
@end

@implementation MMAccessor

__singleton__(MMAccessor)

- (id)resourceWithURI:(MMURI *)uri {
    id delegate = [[MMBundleManager sharedInstance] bundleDelegateForIdentifier:uri.identifier];
    if([delegate respondsToSelector:@selector(resourceForURI:)]) {
        return [delegate resourceForURI:uri];
    }
    MMLogInfo(@"***For***: not implemented for target %@", uri.target);
    return nil;
}

- (id)performAction:(NSString *)actionName withTarget:(NSString *)targetName parameters:(NSDictionary *)parameters shouldCacheTarget:(BOOL)shouldCacheTarget {
    NSString *classString = [NSString stringWithFormat:@"%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"%@:", actionName];
    Class targetClass;
    
    NSObject *target = self.cachedTarget[classString];
    if (target == nil) {
        targetClass = NSClassFromString(classString);
        target = [[targetClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self NoTargetActionResponseWithTargetString:classString selectorString:actionString originParameters:parameters];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[classString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:parameters];
    } else {
        // 有可能target是Swift对象
        actionString = [NSString stringWithFormat:@"%@WithParams:", actionName];
        action = NSSelectorFromString(actionString);
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:parameters];
        } else {
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
            SEL action = NSSelectorFromString(@"notFound:");
            if ([target respondsToSelector:action]) {
                return [self safePerformAction:action target:target params:parameters];
            } else {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                [self NoTargetActionResponseWithTargetString:classString selectorString:actionString originParameters:parameters];
                [self.cachedTarget removeObjectForKey:classString];
                return nil;
            }
        }
    }
}

- (void)releaseCachedTargetWithTarget:(NSString *)targetName {
    NSString *targetClassString = [NSString stringWithFormat:@"%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - private methods
- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParameters:(NSDictionary *)originParams {
    SEL action = NSSelectorFromString(@"response:");
    NSObject *target = [[NSClassFromString(@"NoTargetAction") alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;
    
    [self safePerformAction:action target:target params:params];
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params {
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget {
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

@end
