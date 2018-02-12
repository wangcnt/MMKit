//
//  UIDeviceAdditions.h
//  QTTime
//
//  Created by Mark on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice(Additions)

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

@end
