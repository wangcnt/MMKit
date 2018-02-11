//
//  AKUploadRequest.h
//  AnalyticsKit
//
//  Created by WangQiang on 2018/2/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import "AKHTTPRequest.h"

@protocol AKEvent;

@interface AKUploadRequest : AKHTTPRequest
@property (nonatomic, strong) NSArray<id<AKEvent>> *events;
@end
