//
//  QTServiceCenter.h
//  QTimeUI
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMCoreServices/MMCoreServices.h>
#import <QTimeFoundation/QTimeFoundation.h>

@interface QTServiceCenter : MMServiceCenter
<QTService>

+ (instancetype)sharedInstance;

@end
