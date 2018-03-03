//
//  QTSessionManager.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMCoreServices/MMCoreServices.h>

@protocol QTSessionManager <MMSessionManager>
@end

@protocol QTHTTPSessionManager <QTSessionManager>
@end

@interface QTSessionManager : MMSessionManager <QTSessionManager>
@end

@interface QTHTTPSessionManager : QTSessionManager <QTHTTPSessionManager>
@end
