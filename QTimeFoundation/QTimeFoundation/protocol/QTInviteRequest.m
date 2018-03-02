//
//  QTInviteRequest.m
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTInviteRequest.h"
#import "QTInviteResponse.h"

@implementation QTInviteRequest

- (NSString *)command {
    return @"invite";
}

- (Class<MMResponse>)responseClass {
    return QTInviteResponse.class;
}

- (NSData *)payload {
    NSString *names = [_names componentsJoinedByString:@", "];
    return [names dataUsingEncoding:NSUTF8StringEncoding];
}

@end
