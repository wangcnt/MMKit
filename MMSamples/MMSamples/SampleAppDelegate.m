//
//  SampleAppDelegate.m
//  MMSamples
//
//  Created by Mark on 2018/4/7.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "SampleAppDelegate.h"

#import <AnalyticsKit/AnalyticsKit.h>
#import <MMLog/MMLog.h>
#import <MMCoreServices/MMCoreServices.h>
#import <MMFoundation/MMFoundation.h>
#import <MMFoundation/NSExceptionAdditions.h>
#import <MMUIKit/MMUIKit.h>
//#import <QTimeUI/QTimeUI.h>
#import <objc/runtime.h>

#import "MMChain.h"

#import "FirstViewController.h"
#import "SecondViewController.h"

#import "MMSafeSingleton.h"
#import "MMSomething.h"

#import <MMRuntime/MMRuntime.h>

__c_stringify__(abcde)
__stringify__(abcdefg)

@interface SampleAppDelegate ()
@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, retain) NSString *what;
@end


@interface AA : NSObject
- (void)print;
@end

@implementation AA
- (void)print {
    NSLog(@"AA");
}
- (Class)class {
    return NSClassFromString(@"AA");
}
@end

@interface BB : AA
@end

@implementation BB
- (void)print {
    NSLog(@"self.class -> %@", self.class);
    NSLog(@"super.class -> %@", [super class]);
    NSLog(@"BB");
}

- (Class)class {
    return NSClassFromString(@"BB");
}

@end

@implementation SampleAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL aaa = [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[MMBundleManager sharedInstance] installEmbeddedBundles];
    
    [self testMMURI];
    
    [self testPredicateEqualEmptyString];
    
    // Override point for customization after application launch.
    //    [[B sharedInstance] print];
    //    [self test_MMServiceCenter];
    
    //    NSLog(@"%@", NSStringFromClass([self class])); // Son
    //    NSLog(@"%@", NSStringFromClass([super class])); // Son
    //    NSLog(@"%@", NSStringFromClass([self superclass])); // Son
    
    //    AA *aa = [[AA alloc] init];
    //    [aa print];
    //    BB *bb = [[BB alloc] init];
    //    [bb print];
    
    
    //    self.supportsShakingToEdit = YES;
    
    //    [self test_defines];
    
    //    [self test_chainedInvocation];
    
    //    [self test_InvokeWithBlockArgument];
    //    [self test_OverrideProperty];
    
    //    [self test_InstalledAllApps];
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    //    [self test_SafeSingleton];
    
    //    [self test_DDLog];
    
    //    [self gcdDemo1];
    //    [self gcdDemo2];
    //    [self gcdDemo3];
    //    [self gcdDemo5];
    //    [self test_DynamicProxy];
    //    [self test_StringAdditions];
    
    //    [self testDistinct];
//    [self testSort];
    [self setupWindow];
    //    [self test_EnumerateSubviews];
    self.window.backgroundColor = mm_rgba_color(200, 100, 150, 1);
    
    return aaa;
}

- (void)testPredicateEqualEmptyString {
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"", @"a", @"bb", @"ccc", nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"! SELF CONTAINS '' && length>=2"];
    [arr filterUsingPredicate:predicate];
    NSLog(@"filterred array -> %@", arr);
}

- (void)testMMURI {
    void (^step)(NSString *) = ^(NSString *step) {
        NSLog(@"%@", step);
    };
    void (^completion)(NSError *) = ^(NSError *error) {
        if(error) {
            NSLog(@"Shut up and go away!");
        } else {
            NSLog(@"大吉大利，今晚吃鸡.");
        }
    };
    MMURI *uri = [MMURI URIWithString:@"ui://com.mark.halo.time/invite?name=XiaoLi"];
    uri.parameters = @{ @"step" : step,
                        @"completion" : completion
                        };
    [[MMAccessor sharedInstance] resourceWithURI:uri];
}

- (void)testSort {
    NSMutableArray<NSNumber *> *numbers = [NSMutableArray arrayWithObjects:@1, @6, @3, @1, @5, @4, nil];
    numbers = [NSMutableArray arrayWithObjects:@1, @2, @3, @4, @5, @6, nil];
    [numbers reverse];
    //    numbers = [NSMutableArray arrayWithObjects:nil];
    
    int m = 2;
    if(m == 0) {
        // pop
        for(NSInteger i=numbers.count-1; i>=0; i--) {
            //        for(int i=0; i<numbers.count; i++) {
            for(int j=0; j<numbers.count-1; j++) {
                if(numbers[j] > numbers[j+1]) {
                    [numbers exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    NSLog(@"number -> %@", [numbers componentsJoinedByString:@"-"]);
                }
            }
        }
    } else if(m == 1) {
        [self quick_sort:numbers withLeft:0 right:(int)numbers.count-1];
    } else if(m == 2) {
        [self select_sort:numbers];
    }
    NSLog(@"numbers -> %@", numbers);
}

/*
 * 快速排序
 *
 * 参数说明：
 *     a -- 待排序的数组
 *     l -- 数组的左边界(例如，从起始位置开始排序，则l=0)
 *     r -- 数组的右边界(例如，排序截至到数组末尾，则r=a.length-1)
 */
- (void)quick_sort:(NSMutableArray<NSNumber *> *)a withLeft:(int)minLeft right:(int)maxRight {
    if (minLeft < maxRight) {
        int left, right, value;
        
        left = minLeft;
        right = maxRight;
        value = a[left].intValue;
        while (left < right) {
            while(left < right && a[right].intValue > value) {
                right--; // 从右向左找第一个小于x的数
            }
            
            if(left < right) {
                a[left++] = a[right];
            }
            NSLog(@"a <- %@", [a componentsJoinedByString:@"-"]);
            
            while(left < right && a[left].intValue < value) {
                left++; // 从左向右找第一个大于x的数
            }
            
            if(left < right) {
                a[right--] = a[left];
            }
            NSLog(@"a -> %@", [a componentsJoinedByString:@"="]);
        }
        a[left] = @(value);
        
        NSLog(@"seperated at left[%d] right[%d]", left, right);
        
        [self quick_sort:a withLeft:minLeft right:left-1]; /* 递归调用 */
        [self quick_sort:a withLeft:left+1 right:maxRight]; /* 递归调用 */
    }
}

- (void)select_sort:(NSMutableArray *)a
{
    NSInteger n = a.count;
    
    int i;        // 有序区的末尾位置
    int j;        // 无序区的起始位置
    int min;    // 无序区中最小元素位置
    
    for(i=0; i<n; i++) {
        min=i;
        
        // 找出"a[i+1] ... a[n]"之间的最小元素，并赋值给min。
        for(j=i+1; j<n; j++) {
            if(a[j] < a[min]) {
                min=j;
            }
        }
        
        // 若min!=i，则交换 a[i] 和 a[min]。
        // 交换之后，保证了a[0] ... a[i] 之间的元素是有序的。
        if(min != i) {
            [a exchangeObjectAtIndex:i withObjectAtIndex:min];
        }
        
        NSLog(@"a -> %@", [a componentsJoinedByString:@"-"]);
    }
}

- (void)bucket_sort:(NSMutableArray *)a withMaxBucket:(int)max
{
    __unused int i, j, n = (int)a.count;
    __unused NSMutableArray *buckets = [NSMutableArray array];
    
    if (a==NULL || n<1 || max<1)
        return ;
    
    // 1. 计数
    //    for(i = 0; i < n; i++)
    //        buckets[a[i]]++;
    //
    //    // 2. 排序
    //    for (i = 0, j = 0; i < max; i++)
    //        while( (buckets[i]--) >0 )
    //            a[j++] = i;
    //
    //    free(buckets);
}

- (void)testDistinct {
    NSArray *array = @[@"11", @"12", @"13", @"14", @"15", @"12"];
    __unused NSArray *array1 = [array valueForKeyPath:@"@distinctUnionOfObjects.self"];
    __unused NSSet *set = [NSSet setWithArray:array];
    __unused NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:array];
    
    NSLog(@"%@", array);
}

- (void)test_defines {
    NSLog(@"abcde->%s", abcde);
    NSLog(@"abcdefg->%@", abcdefg);
    NSLog(@"");
    
    void (^block)(NSString *, NSString *) = ^ (NSString *surname, NSString *name) {
        NSLog(@"Hello, %@ %@", surname, name);
    };
    
    NSString *string = @"a";
    __weakify__(string);
    NSLog(@"weakedstring->%@", weakedstring);
    __strongify__(string);
    NSLog(@"strongedstring->%@", strongedstring);
    __mm_exe_block__(block, NO, @"Kalma", @"Lancelot.");
    
    NSString *b = @"b";
    @weakify(self, b);
    _haha = ^ (NSError *error) {
        @strongify(self);
        NSLog(@"self.class -> %@, b -> %@", self.class, b_weak_);
    };
    
    NSString *e = @"e";
    @weakify(string, e);
    _haha = ^ (NSError *error) {
        NSLog(@"self.string -> %@, e -> %@", string_weak_, e_weak_);
    };
    
    _haha(nil);
}

- (void)test_chainedInvocation {
    MMChain *sth = [[MMChain alloc] init];
    sth.addString(@"Hello, Lancelot, I will give you ¥")
    .addInteger(123)
    .addString(@" to invite the girl.")
    .print();
}

- (void)test_OverrideProperty {
    B *b = [[B alloc] init];
    b.ha = @"haaaaaa";
    
    MMSubthing *sth = [[MMSubthing alloc] init];
    sth.a = b;
    [sth print];
}

- (void)test_SafeSingleton {
    __unused id shared = [MMSafeSingleton sharedInstance];
    MMSafeSingleton *inited = [[MMSafeSingleton alloc] init];
    __unused id copied = [inited copy];
    __unused id mutableCopied = [inited mutableCopy];
    NSLog(@"safe.singleton.name-->%@", [MMSafeSingleton sharedInstance].name);
}

- (void)test_InstalledAllApps {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    Class c =NSClassFromString(@"LSApplicationWorkspace");
    id s = [(id)c performSelector:NSSelectorFromString(@"defaultWorkspace")];
    NSArray *array = [s performSelector:NSSelectorFromString(@"allInstalledApplications")];
    for (id item in array) {
        NSLog(@"%@-%@",
              [item performSelector:NSSelectorFromString(@"applicationIdentifier")],
              [item performSelector:NSSelectorFromString(@"bundleVersion")]);
        //NSLog(@"%@",[item performSelector:NSSelectorFromString(@"bundleIdentifier")]);
    }
#pragma clang diagnostic pop
}

- (BOOL)test_ChangeReturnValueWhenDebugging {
    return YES;
}

- (void)test_InvokeWithBlockArgument {
    NSString *identifier = @"Mark Wong";
    void (^completion)(MMSomething *) = ^ (MMSomething *something) {
        [something print];
    };
    MMSomething *something = [[MMSomething alloc] init];
    SEL selector = @selector(fetchSomethingWithIdentifier:completion:);
    NSMethodSignature *signature = [something methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = something;
    invocation.selector = selector;
    [invocation setArgument:&identifier atIndex:2];
    [invocation setArgument:&completion atIndex:3];
    [invocation retainArguments];
    
    NSLog(@"I will be back in 5s.");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [invocation invoke];
    });
}

- (void)setupWindow {
    MMTabBarController *tabController = [[MMTabBarController alloc] init];
    
    MMURI *uri = [MMURI URIWithString:@"ui://com.mark.halo.time/main"];
    UIViewController *timeController = [[MMAccessor sharedInstance] resourceWithURI:uri];
    MMNavigationController *timeNavController = nil;
    if(timeController) {
        timeNavController = [[MMNavigationController alloc] initWithRootViewController:timeController];
        timeNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Time" image:nil tag:3];
    }
    
    FirstViewController *fController = [[FirstViewController alloc] init];
    MMNavigationController *fNavController = [[MMNavigationController alloc] initWithRootViewController:fController];
    fNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"First" image:nil tag:2];
    
    SecondViewController *sController = [[SecondViewController alloc] init];
    MMNavigationController *sNavController = [[MMNavigationController alloc] initWithRootViewController:sController];
    sNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Second" image:nil tag:3];
    
    NSMutableArray *controllers = [NSMutableArray array];
    if(timeNavController) {
        [controllers addObject:timeNavController];
    }
    [controllers addObject:fNavController];
    [controllers addObject:sNavController];
    tabController.viewControllers = controllers;
    
    _window.rootViewController = tabController;
}

- (void)test_EnumerateSubviews {
    NSString *result = [_window subhierarchyString];
    NSLog(@"window.hierarchy:%@", result);
    __block int count = 0;
    [_window enumerateSubviewsRecursively:YES usingBlock:^(UIView *subview, BOOL *stop) {
        if([subview isKindOfClass:UILabel.class]) {
            count ++;
            if(count == 3) {
                *stop = YES;
            }
        }
        NSLog(@"subview -> %@", subview.class);
    }];
}

- (void)test_additions {
    __unused NSComparisonResult greater = [@"a1.b2" compareVersion:@"a1asdf.c2(**HIUHIHIOHIHKHJGYUIOHIbkdsf3"];
    __unused NSArray<NSNumber *> *numbers = [@"1.2.3.4a3b*(Id2" numbers];
    NSLog(@"");
    
    NSMutableArray *arr = @[@"a", @"b", @"c"].mutableCopy;
    [arr insertObjects:@[@1, @2, @3] atIndex:0];
    [arr prependObjects:@[@"!", @"@", @"#"]];
    NSLog(@"arr -> %@", arr);
}

- (void)test_DDLog {
    MMLogManager *manager = [MMLogManager sharedInstance];
    manager.maximumFileSize = 1024 * 1;   // 1K
    manager.rollingFrequency = 60; // 1 minute
    manager.maximumNumberOfLogFiles = 3;
    //    manager.TTYEnabled = YES;
    manager.ASLEnabled = YES;
    manager.logsDirectory = mm_document_path();
    NSLog(@"log path-->%@", [MMLogManager sharedInstance].logPaths);
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self  selector:@selector(writeLogMessages:) userInfo:nil repeats:YES];
    
    NSLog(@"Wakakakakakakaak");
    MMLogWarning(@"Wakakakakakakaak");
}

- (void)writeLogMessages:(NSTimer *)aTimer {
    MMLogWarning(@"I like cheese");
}

- (void)test_MMServiceCenter {
    MMServiceCenter<MMService, AKService> *center = [[MMServiceCenter<MMService, AKService> alloc] init];
    center.scope = MMServiceScopeGlobal;
    NSLog(@"center.scope --> %ld", center.scope);
    
    MMService *service = [[MMService alloc] init];
    [center registerService:service];
    
    AKService *akService = [[AKService alloc] init];
    [center startService:akService];
    
    [center uploadEvent:nil withCompletion:^(NSError *error) {
        NSLog(@"");
    }];
    
    [center startService];
}

/**
 *  因为是异步，所以开通了子线程，但是因为是串行队列，所以只需要开通1个子线程（2），它们在子线程中顺序执行。最常用。
 */
-(void)gcdDemo1{
    dispatch_queue_t q1=dispatch_queue_create("com.hellocation.gcdDemo", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<10; i++) {
        dispatch_async(q1, ^{
            NSLog(@"%@",[NSThread currentThread]);
        });
    }
}
/**
 *  因为是异步，所以开通了子线程，且因为是并行队列，所以开通了好多个子线程，具体几个，无人知晓，看运气。线程数量无法控制，且浪费。
 */
-(void)gcdDemo2{
    dispatch_queue_t q2=dispatch_queue_create("com.hellocation.gcdDemo", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0; i<10; i++) {
        dispatch_async(q2, ^{
            NSLog(@"%@",[NSThread currentThread]);
        });
    }
}
/**
 *  因为是同步，所以无论是并行队列还是串行队列，都是在主线程中执行
 */
-(void)gcdDemo3{
    dispatch_queue_t q1=dispatch_queue_create("com.hellocation.gcdDemo", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<10; i++) {
        dispatch_sync(q1, ^{
            NSLog(@"%@",[NSThread currentThread]);
        });
    }
}
/**
 *  全局队列和并行队列类似（全局队列不需要创建直接get即可，而导致其没有名字，不利于后续调试）
 */
-(void)gcdDemo5{
    dispatch_queue_t q=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i=0; i<10; i++) {
        dispatch_sync(q, ^{
            NSLog(@"%d, %@", i, [NSThread currentThread]);
        });
    }
    for (int i=0; i<10; i++) {
        dispatch_async(q, ^{
            NSLog(@"%d ------%@", i, [NSThread currentThread]);
        });
    }
}
/**
 *  因为是主线程，所以异步任务也会在主线程上运行（1）。而如果是同步任务，则阻塞了，因为主线程一直会在运行，所以后米的任务永远不会被执行。
 *  主要用处，是更新UI，更新UI一律在主线程上实现
 */
-(void)gcdDemo6{
    dispatch_queue_t q=dispatch_get_main_queue();
    for (int i=0; i<10; i++) {
        dispatch_sync(q, ^{
            NSLog(@"%@",[NSThread currentThread]);
        });
    }
    //    for (int i=0; i<10; i++) {
    //        dispatch_async(q, ^{
    //            NSLog(@"%@",[NSThread currentThread]);
    //        });
    //    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
