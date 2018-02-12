//
//  AppDelegate.m
//  MMExamples
//
//  Created by Mark on 2018/1/30.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AppDelegate.h"
#import <MMArchitecture/MMArchitecture.h>
#import <MMFoundation/MMFoundation.h>

#import "DPPersonProxy.h"
#import "DPPerson.h"
#import "DPPersonProtocol.h"

#import <MMLog/MMLog.h>


@interface A : NSObject
+ (instancetype)sharedInstance;
- (void)print;
@end

@implementation A
+ (instancetype)sharedInstance {
    static A *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[A alloc] init];
    });
    return instance;
}
- (void)print {
    NSLog(@"A haha");
}
@end

@interface B : A
@end

@implementation B
- (void)print {
    NSLog(@"B haha");
}
@end

@interface MTUserDefaults : NSUserDefaults
- (void)print;
@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[B sharedInstance] print];
    [self testMMService];
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"aaaaa"];
    string = [NSMutableString stringWithString:@"aaaab"];
    if([string isKindOfClass:NSMutableString.class]) {
//        if([string respondsToSelector:@selector(deleteBeforeString:)]) {
//            [string deleteBeforeString:@"b"];
//        [string deleteOccurrencesOfString:@"a"];
        [string JSONObject];
        [string deleteCharactersInRange:NSMakeRange(0, 2)];
//        }
    }
    NSLog(@"string-->%@", string);
    
//    [self gcdDemo1];
//    [self gcdDemo2];
//    [self gcdDemo3];
//    [self gcdDemo5];
    [self testDynamicProxy];
    return YES;
}

- (void)testDynamicProxy {
    DPPerson *person = [[DPPerson alloc] init];
    id<DPPersonProtocol> proxy = [[DPPersonProxy alloc] initWithPerson:person];
//    [proxy goDie];
//    [proxy eat];
//    BOOL isAGoodGuy = [proxy isAGoodGuy];
//    [proxy buyFish:@"娃娃魚" withMoney:50.555];
    [proxy bathWithCompletion:^(BOOL successed) {
        NSLog(@"successed-->%d", successed);
    }];
}

- (void)testMMService {
    double begin = CFAbsoluteTimeGetCurrent();
    MMService *service = [[MMService alloc] init];
    [service startService];
//    for(int i=0; i<3; i++) {
//        [service loginWithUsername:@"wangcnt" password:@"Aizaih0" completion:^(NSError *error) {
//            //            NSLog(@"i............%d", 0);
//        }];
//    }
//    [service.highQueue waitUntilAllOperationsAreFinished];
    double end = CFAbsoluteTimeGetCurrent();
    double duaring = end - begin;
//    NSLog(@"duaring -> %f", duaring);
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
