//
//  QTService.m
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTService.h"

#import "QTInviteOperation.h"
#import "QTSessionConfiguration.h"
#import "QTInviteConnection.h"
#import "QTInviteSessionManager.h"
#import <MMCoreServices/MMCoreServices.h>

@interface QTService ()
@property (nonatomic, strong) QTSessionConfiguration *sessionConfiguration;
@end

@implementation QTService

- (instancetype)init {
    if(self = [super init]) {
        QTInviteSessionManager *inviteSessionManager = [[QTInviteSessionManager alloc] init];
        _sessionConfiguration = [[QTHTTPSessionConfiguration alloc] init];
        _sessionConfiguration.database_queue = dispatch_queue_create("com.markwong.time.db.queue", DISPATCH_QUEUE_SERIAL);
        _sessionConfiguration.task_queue = dispatch_queue_create("com.markwong.time.task.queue", DISPATCH_QUEUE_SERIAL);
        _sessionConfiguration.connectionClass = QTInviteConnection.class;
        _sessionConfiguration.sessionManager = inviteSessionManager;
    }
    return self;
}

- (void)inviteTheGirlWithName:(NSString *)name step:(MMRequestStepHandler)step completion:(void (^)(NSError *error))completion {
    if(!name) return;
    QTInviteOperation *operation = [[QTInviteOperation alloc] initWithNames:@[name]];
    operation.configuration = _sessionConfiguration;
    operation.step = ^(MMRequestStep stp) {
        if(step) {
            dispatch_async(dispatch_get_main_queue(), ^{
                step(stp);
            });
        }
    };
    __weak typeof(QTInviteOperation) *weakedOp = operation;
    operation.completionBlock = ^{
        [self callbackWithCompletion:completion error:weakedOp.error toMainThread:YES];
    };
    [[MMApplication sharedInstance].defaultQueue addOperation:operation];
}

@end
