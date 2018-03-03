//
//  QTRequest.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMCoreServices/MMCoreServices.h>

@protocol QTRequest <MMRequest>
@end

@protocol QTHTTPRequest <QTRequest>
@end

@interface QTRequest : MMRequest <QTRequest>
@end

@interface QTHTTPRequest : QTRequest <QTHTTPRequest>
@end
