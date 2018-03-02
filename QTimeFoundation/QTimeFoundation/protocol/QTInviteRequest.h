//
//  QTInviteRequest.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTRequest.h"

@interface QTInviteRequest : QTHTTPRequest
@property (nonatomic, strong) NSArray<NSString *> *names;
@end
