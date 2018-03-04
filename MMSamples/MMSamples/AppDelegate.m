//
//  AppDelegate.m
//  MMSamples
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AppDelegate.h"

#import <AnalyticsKit/AnalyticsKit.h>
#import <MMLog/MMLog.h>
#import <MMCoreServices/MMCoreServices.h>
#import <MMFoundation/MMFoundation.h>
#import <MMUIKit/MMUIKit.h>
#import <QTimeUI/QTimeUI.h>

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //    [[B sharedInstance] print];
    [self testMMServiceCenter];
    
    //    [self testDDLog];
    
    //    [self gcdDemo1];
    //    [self gcdDemo2];
    //    [self gcdDemo3];
    //    [self gcdDemo5];
    //    [self testDynamicProxy];
    //    [self testStringAdditions];
    
    NSArray *strs = @[@"c", @"b", @"a", @"啊"];
    for(int i=0; i<strs.count; i++) {
        NSString *str = strs[i];
        ;
        NSLog(@"strs[%d]-->%@", i, str);
    }
    int j = 255;
    BOOL result = [self testChangeReturnValueWhenDebugging];
    
    [self setupWindow];
    
    return YES;
}

- (BOOL)testChangeReturnValueWhenDebugging {
    return YES;
}

- (void)setupWindow {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    MMTabBarController *tabController = [[MMTabBarController alloc] init];
    
    FirstViewController *fController = [[FirstViewController alloc] init];
    MMNavigationController *fNavController = [[MMNavigationController alloc] initWithRootViewController:fController];
    fNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"First" image:nil tag:1];
    
    SecondViewController *sController = [[SecondViewController alloc] init];
    MMNavigationController *sNavController = [[MMNavigationController alloc] initWithRootViewController:sController];
    sNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Second" image:nil tag:2];
    
    QTHomepageViewController *timeController = [[QTHomepageViewController alloc] init];
    MMNavigationController *timeNavController = [[MMNavigationController alloc] initWithRootViewController:timeController];
    timeNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Time" image:nil tag:3];
    
    tabController.viewControllers = @[timeNavController, fNavController, sNavController];
    
    _window.rootViewController = tabController;
    
    [_window makeKeyAndVisible];
    
    NSLog(@"1");
}

- (void)testStringAdditions {
    NSComparisonResult greater = [@"a1.b2" compareVersion:@"a1asdf.c2(**HIUHIHIOHIHKHJGYUIOHIbkdsf3"];
    NSArray<NSNumber *> *numbers = [@"1.2.3.4a3b*(Id2" numbers];
}

- (void)testDDLog {
    [[MMLogManager sharedInstance] config];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self  selector:@selector(writeLogMessages:) userInfo:nil repeats:YES];
}

- (void)writeLogMessages:(NSTimer *)aTimer {
    MMLogWarning(@"I like cheese");
}

- (void)testMMServiceCenter {
    MMServiceCenter<MMService, AKService> *center = [[MMServiceCenter<MMService, AKService> alloc] init];
    center.scope = MMServiceScopeGlobal;
    NSLog(@"center.scope --> %ld", center.scope);
    
    MMService *service = [[MMService alloc] init];
    [center registerService:service];
    
    AKService *akService = [[AKService alloc] init];
    [center registerService:akService];
    
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
