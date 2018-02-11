//
//  AKEvent.h
//  AnalyticsKit
//
//  Created by WangQiang on 2018/2/11.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKEvent <NSObject, NSCoding>

@end

@interface AKEvent : NSObject <AKEvent>

@end
