//
//  QTOperation.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMArchitecture/MMArchitecture.h>

@protocol QTOperation <MMOperation>
@end

@protocol QTHTTPOperation <QTOperation>
@end

@interface QTOperation : MMOperation
@end

@interface QTHTTPOperation : QTOperation <QTHTTPOperation>
@end
