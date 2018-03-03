//
//  AKEvent.m
//  AnalyticsKit
//
//  Created by Mark on 2018/2/11.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "AKEvent.h"

@implementation AKEvent
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.eventId = [aDecoder decodeObjectForKey:@"eventId"];
        self.eventName = [aDecoder decodeObjectForKey:@"eventName"];
        self.pageId = [aDecoder decodeObjectForKey:@"pageId"];
        self.pageName = [aDecoder decodeObjectForKey:@"pageName"];
        self.remark = [aDecoder decodeObjectForKey:@"remark"];
        self.extraInfo = [aDecoder decodeObjectForKey:@"extraInfo"];
        self.timestamp = [aDecoder decodeDoubleForKey:@"timestamp"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.type forKey:@"type"];
    if(self.eventId) {
        [aCoder encodeObject:self.eventId forKey:@"eventId"];
    }
    if(self.eventName) {
        [aCoder encodeObject:self.eventName forKey:@"eventName"];
    }
    if(self.pageId) {
        [aCoder encodeObject:self.pageId forKey:@"pageId"];
    }
    if(self.pageName) {
        [aCoder encodeObject:self.pageName forKey:@"pageName"];
    }
    if(self.remark) {
        [aCoder encodeObject:self.remark forKey:@"remark"];
    }
    if(self.extraInfo) {
        [aCoder encodeObject:self.extraInfo forKey:@"extraInfo"];
    }
    [aCoder encodeDouble:self.timestamp forKey:@"timestamp"];
}

@end

@implementation AKTapEvent

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.type = AKEventTypeTap;
    }
    return self;
}

- (AKEventType)type {
    return AKEventTypeTap;
}

@end

@implementation AKTaskEvent

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.duaring = [aDecoder decodeDoubleForKey:@"duaring"];
        self.successed = [aDecoder decodeIntegerForKey:@"successed"];
        self.message = [aDecoder decodeObjectForKey:@"message"];
        self.type = AKEventTypeTask;
    }
    return self;
}

- (AKEventType)type {
    return AKEventTypeTask;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:self.duaring forKey:@"duaring"];
    [aCoder encodeInteger:self.successed forKey:@"successed"];
    if(self.message) {
        [aCoder encodeObject:self.message forKey:@"message"];
    }
}

@end

