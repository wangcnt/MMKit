//
//  UIDeviceAdditions.m
//  QTTime
//
//  Created by WangQiang on 15/5/26.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UIDeviceAdditions.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@implementation UIDevice(Additions)

- (void)setTorchOn:(BOOL)on
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (![device hasTorch])
    {
        NSLog(@"no torch");
    }
    else
    {
        [device lockForConfiguration:nil];
        
        device.torchMode = on ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
        
        [device unlockForConfiguration];
    }
}

//检查前后摄像头
- (void)isCameraEnabled
{
    BOOL cameraAvailable = [UIImagePickerController isCameraDeviceAvailable:
                            UIImagePickerControllerCameraDeviceRear];//前
    
    BOOL frontCameraAvailable = [UIImagePickerController isCameraDeviceAvailable:
                                 UIImagePickerControllerCameraDeviceFront];//后
    
    if(cameraAvailable == frontCameraAvailable){}
}

//检查指南针
- (void)isMagnetometerEnabled
{
    [CLLocationManager headingAvailable];
}

//检查声音支持
- (BOOL)isMicrophoneAvailable
{
    return [AVAudioSession sharedInstance].inputAvailable;//bool值。获取是否支持
}

//检查录像支持 MobileCoreServices.framework <MobileCoreServices/MobileCoreServices.h>
- (BOOL)isVideoCameraEnabled
{
    //简单检查所有的可用的媒体资源类型，然后检查返回的数组，
    //如果其中包含了kUTTypeMovie的NSString类型对象，就证明摄像头支持录像
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //返回所支持的media的类型数组
    NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];

    return ![sourceTypes containsObject:(NSString *)kUTTypeMovie];
}

//检查陀螺仪可用 CoreMotion.framework <CoreMotion/CoreMotion.h>
- (BOOL)isGyroscopeAvailable
{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    
    return motionManager.gyroAvailable;
}

@end
