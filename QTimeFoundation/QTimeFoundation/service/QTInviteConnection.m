//
//  QTInviteConnection.m
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTInviteConnection.h"

#import "QTResponse.h"
#import <MMFoundation/MMDefines.h>

@implementation QTInviteConnection

- (void)sendRequest:(id<MMRequest>)request withCompletion:(MMRequestCompletion)completion {
    // receiving
    __mm_exe_block__(request.stepHandler, NO, MMRequestStepReceiving);
    
    sleep(arc4random() % 5 + 2);
    
    // parsing
    __mm_exe_block__(request.stepHandler, NO, MMRequestStepParsing);
    
    sleep(arc4random() % 5 + 2);
    Class clazz = (Class)request.responseClass;
    QTResponse *response = [[clazz alloc] init];
    response.error = arc4random() % 2 ? nil : [NSError errorWithDomain:MMCoreServicesErrorDomain code:4 userInfo:@{NSLocalizedDescriptionKey : @"Who you've invited is really a man..."}];
    
    // persisting
    __mm_exe_block__(request.stepHandler, NO, MMRequestStepPersisting);
    
    sleep(arc4random() % 5 + 2);
    if(completion) {
        completion(response);
    }
}

@end
