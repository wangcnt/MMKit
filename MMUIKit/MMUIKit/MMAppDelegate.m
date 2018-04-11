//
//  MMAppDelegate.m
//  MMUIKit
//
//  Created by Mark on 2018/4/7.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMAppDelegate.h"

#import <MMMotionKit/MMMotionKit.h>

@implementation MMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)setSupportsShakingToEdit:(BOOL)supportsShakingToEdit {
    BOOL previous = _supportsShakingToEdit;
    if(_supportsShakingToEdit != supportsShakingToEdit) {
        _supportsShakingToEdit = supportsShakingToEdit;
        
        if(_supportsShakingToEdit) {
            [[MMMotionDetector sharedInstance] startDetection];
        } else {
            if(previous == _supportsShakingToEdit) {
                [[MMMotionDetector sharedInstance] stopDetection];
            }
        }
    }
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

#pragma mark -------------------------------------------------------------------
#pragma mark Shaking to edit
- (void)supportsShakingToEditIfNeeds {
    if(_supportsShakingToEdit) {
        
    } else {
        
    }
}

//-(void)startAccelerometer
//{
//    //以push的方式更新并在block中接收加速度
//    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init]
//                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//                                                 [self outputAccelertionData:accelerometerData.acceleration];
//                                                 if (error) {
//                                                     NSLog(@"motion error:%@",error);
//                                                 }
//                                             }];
//}
//
//-(void)outputAccelertionData:(CMAcceleration)acceleration
//{
//    //综合3个方向的加速度
//    double accelerameter =sqrt( pow( acceleration.x , 2 ) + pow( acceleration.y , 2 )
//                               + pow( acceleration.z , 2) );
//    //当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）
//    if (accelerameter>2.3f) {
//        //立即停止更新加速仪（很重要！）
//        [self.motionManager stopAccelerometerUpdates];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //UI线程必须在此block内执行，例如摇一摇动画、UIAlertView之类
//        });
//    }
//}

@end
