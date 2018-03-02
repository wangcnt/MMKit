//
//  QTInviteOperation.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTOperation.h"

@interface QTInviteOperation : QTHTTPOperation

- (instancetype)initWithNames:(NSArray<NSString *> *)names;

@end
