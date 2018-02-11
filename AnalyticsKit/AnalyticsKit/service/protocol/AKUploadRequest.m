//
//  AKUploadRequest.m
//  AnalyticsKit
//
//  Created by WangQiang on 2018/2/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "AKUploadRequest.h"
#import "AKUploadResponse.h"
#import "AKEvent.h"

@implementation AKUploadRequest

- (Class)responseClass {
    return AKUploadResponse.class;
}

- (NSData *)payload {
    NSMutableString *payload = [[NSMutableString alloc] init];
    for(id<AKEvent> e in _events) {
        
    }
    return [payload dataUsingEncoding:NSUTF8StringEncoding];
}

@end
