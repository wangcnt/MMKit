//
//  QTServiceCenter.m
//  QTimeUI
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTServiceCenter.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
#pragma clang diasnostic ignored "-Wobjc-protocol-property-synthesis"

@implementation QTServiceCenter

#pragma clang diagnostic pop

+ (instancetype)sharedInstance {
    static QTServiceCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QTServiceCenter alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        QTService *service = [[QTService alloc] init];
        [self registerService:service];
    }
    return self;
}

@end
