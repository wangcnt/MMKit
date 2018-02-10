//
// Copyright 2011-2014 NimbusKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MMViewRecycler.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "Nimbus requires ARC support."
#endif

@interface MMViewRecycler()
@property (nonatomic, strong) NSMutableDictionary* reuseIdentifiersToRecycledViews;
@end

@implementation MMViewRecycler

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    if ((self = [super init])) {
        _reuseIdentifiersToRecycledViews = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(reduceMemoryUsage)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

#pragma mark - Memory Warnings

- (void)reduceMemoryUsage {
    [self removeAllViews];
}

#pragma mark - Public

- (UIView<MMRecyclableView> *)dequeueReusableViewWithIdentifier:(NSString *)reuseIdentifier {
    NSMutableArray* views = [_reuseIdentifiersToRecycledViews objectForKey:reuseIdentifier];
    UIView<MMRecyclableView>* view = [views lastObject];
    if (nil != view) {
        [views removeLastObject];
        if ([view respondsToSelector:@selector(prepareForReuse)]) {
            [view prepareForReuse];
        }
    }
    return view;
}

- (void)recycleView:(UIView<MMRecyclableView> *)view {
    NSString* reuseIdentifier = nil;
    if ([view respondsToSelector:@selector(reuseIdentifier)]) {
        reuseIdentifier = [view reuseIdentifier];;
    }
    if (nil == reuseIdentifier) {
        reuseIdentifier = NSStringFromClass([view class]);
    }
    if (nil == reuseIdentifier) {
        return;
    }
    NSMutableArray* views = [_reuseIdentifiersToRecycledViews objectForKey:reuseIdentifier];
    if (nil == views) {
        views = [[NSMutableArray alloc] init];
        [_reuseIdentifiersToRecycledViews setObject:views forKey:reuseIdentifier];
    }
    [views addObject:view];
}

- (void)removeAllViews {
    [_reuseIdentifiersToRecycledViews removeAllObjects];
}

@end

@implementation MMRecyclableView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:CGRectZero])) {
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:nil];
}

@end
