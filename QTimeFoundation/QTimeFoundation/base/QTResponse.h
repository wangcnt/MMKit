//
//  QTResponse.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMArchitecture/MMArchitecture.h>

@protocol QTResponse <MMResponse>
@end

@protocol QTHTTPResponse <QTResponse>
@end

@interface QTResponse : MMResponse <QTResponse>
@end

@interface QTHTTPResponse : QTResponse <QTHTTPResponse>
@end
