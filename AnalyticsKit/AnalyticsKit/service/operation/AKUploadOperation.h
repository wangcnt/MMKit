//
//  AKUploadOperation.h
//  AnalyticsKit
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AKHTTPOperation.h"

@protocol AKEvent;

@interface AKUploadOperation : AKHTTPOperation
@property (nonatomic, strong) NSArray<id<AKEvent>> *events;
@end
