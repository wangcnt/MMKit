//
//  AKEvent.h
//  AnalyticsKit
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AKEventType) {
    AKEventTypeUnknown,
    AKEventTypeTap,
    AKEventTypeTask
};

@protocol AKEvent <NSObject, NSCoding>

@required
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *pageId;
@property (nonatomic, strong) NSString *extraInfo;  ///< Extra info string from a NSDictionary
@property (nonatomic, assign) NSTimeInterval timestamp;

@property (nonatomic, assign) AKEventType type;

@optional
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, strong) NSString *remark;

- (NSData *)payload;

@end

@protocol AKTapEvent <AKEvent>
@end

@protocol AKTaskEvent <AKEvent>
@required
@property (nonatomic, assign) NSTimeInterval duaring;
@property (nonatomic, assign) BOOL successed;
@property (nonatomic, strong) NSString *message;
@end

@interface AKEvent : NSObject <AKEvent>

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *pageId;
@property (nonatomic, strong) NSString *extraInfo;  ///< Extra info string from a NSDictionary
@property (nonatomic, assign) NSTimeInterval timestamp;

@property (nonatomic, assign) AKEventType type;

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, strong) NSString *remark;

@end

@interface AKTapEvent : AKEvent <AKTapEvent>
@end

@interface AKTaskEvent : AKEvent <AKTaskEvent>
@property (nonatomic, assign) NSTimeInterval duaring;
@property (nonatomic, assign) BOOL successed;
@property (nonatomic, strong) NSString *message;
@end
