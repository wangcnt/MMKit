//
//  QTConnection.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMCoreServices/MMCoreServices.h>

@protocol QTConnection <MMConnection>
@end

@protocol QTHTTPConnection <QTConnection>
@end

@interface QTConnection : MMConnection <QTConnection>
@end

@interface QTHTTPConnection : QTConnection <QTHTTPConnection>
@end
