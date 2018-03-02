//
//  QTInviteSessionManager.m
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTInviteSessionManager.h"

@implementation QTInviteSessionManager

- (void)startRequest:(id<MMRequest>)request withCompletion:(MMRequestCompletion)completion {
    Class clazz = (Class)request.configuration.connectionClass;
    id<MMConnection> connection = [[clazz alloc] init];
    [connection sendRequest:request withCompletion:completion];
}

@end
