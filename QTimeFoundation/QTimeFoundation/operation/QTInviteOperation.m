//
//  QTInviteOperation.m
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTInviteOperation.h"

#import "QTInviteRequest.h"

@interface QTInviteOperation ()
@property (nonatomic, strong) NSArray<NSString *> *names;
@property (nonatomic, strong) QTInviteRequest *inviteRequest;
@end

@implementation QTInviteOperation

- (instancetype)initWithNames:(NSArray<NSString *> *)names {
    if(self = [super init]) {
        self.names = names;
        _inviteRequest = [[QTInviteRequest alloc] init];
        _inviteRequest.names = names;
        
        _request = _inviteRequest;
    }
    return self;
}

- (void)loadFinished {
    dispatch_async(self.configuration.database_queue, ^{
        NSLog(@"Persisting...");
    });
    [super loadFinished];
}

@end
