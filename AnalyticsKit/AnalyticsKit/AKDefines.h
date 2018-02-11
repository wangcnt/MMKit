//
//  AKDefines.h
//  AnalyticsKit
//
//  Created by WangQiang on 2018/2/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#ifndef AKDefines_h
#define AKDefines_h

@protocol AKEvent, MMService;

@protocol AKService <NSObject, MMService>
@required
- (void)uploadEvent:(id<AKEvent>)event withCompletion:(void (^)(NSError *error))completion;
- (void)uploadEvents:(NSArray<id<AKEvent>> *)events withCompletion:(void (^)(NSError *error))completion;
@end

#endif /* AKDefines_h */
