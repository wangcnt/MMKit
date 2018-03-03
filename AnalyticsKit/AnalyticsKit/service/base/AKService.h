//
//  AKService.h
//  AnalyticsKit
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMCoreServices/MMCoreServices.h>

@protocol AKEvent;

@protocol AKService <NSObject, MMService>
@required
- (void)uploadEvent:(id<AKEvent>)event withCompletion:(void (^)(NSError *error))completion;
- (void)uploadEvents:(NSArray<id<AKEvent>> *)events withCompletion:(void (^)(NSError *error))completion;
@end

@interface AKService : MMService <NSObject, AKService>
@end
