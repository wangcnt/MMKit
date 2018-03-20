//
//  AKServiceCenter.h
//  AnalyticsKit
//
//  Created by Mark on 2018/3/18.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <MMCoreServices/MMCoreServices.h>

#import "AKService.h"

@interface AKServiceCenter : MMServiceCenter
<AKService>

+ (instancetype)sharedInstance;

@end
