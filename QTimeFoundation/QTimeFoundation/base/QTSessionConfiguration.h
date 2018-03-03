//
//  QTSessionConfiguration.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMCoreServices/MMCoreServices.h>

@protocol QTSessionConfiguration <MMSessionConfiguration>
@end

@protocol QTHTTPSessionConfiguration <QTSessionConfiguration>
@end

@interface QTSessionConfiguration : MMSessionConfiguration <QTSessionConfiguration>
@end

@interface QTHTTPSessionConfiguration : QTSessionConfiguration <QTHTTPSessionConfiguration>
@end
