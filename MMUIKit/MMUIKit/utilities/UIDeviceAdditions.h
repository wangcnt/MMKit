//
//  UIDeviceAdditions.h
//  QTTime
//
//  Created by Mark on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice (Additions)

@end

@interface UIDevice (Hardware)

- (void)setTorchOn:(BOOL)on;

//检查前后摄像头
- (BOOL)isCameraEnabled;

//检查指南针
- (BOOL)isMagnetometerEnabled;

//检查声音支持
- (BOOL)isMicrophoneAvailable;

//检查录像支持 MobileCoreServices.framework <MobileCoreServices/MobileCoreServices.h>
- (BOOL)isVideoCameraEnabled;

//检查陀螺仪可用 CoreMotion.framework <CoreMotion/CoreMotion.h>
- (BOOL)isGyroscopeAvailable;

+ (NSString *)platform;
+ (NSString *)platformString;


+ (NSString *)macAddress;

//Return the current device CPU frequency
+ (NSUInteger)cpuFrequency;
// Return the current device BUS frequency
+ (NSUInteger)busFrequency;
//current device RAM size
+ (NSUInteger)ramSize;
//Return the current device CPU number
+ (NSUInteger)cpuNumber;
//Return the current device total memory

/// 获取iOS系统的版本号
+ (NSString *)systemVersion;
/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)totalDiskSpaceBytes;

@end
