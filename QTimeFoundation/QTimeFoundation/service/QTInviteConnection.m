//
//  QTInviteConnection.m
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTInviteConnection.h"

#import "QTResponse.h"

@implementation QTInviteConnection

- (void)sendRequest:(id<MMRequest>)request withCompletion:(MMRequestCompletion)completion {
    int seconds = arc4random() % 5 + 2;
    NSLog(@"%@ing...", request.command);
    sleep(seconds);
    Class clazz = (Class)request.responseClass;
    QTResponse *response = [[clazz alloc] init];
    response.error = seconds / 2 ? nil : [NSError errorWithDomain:@"QTServiceErrorDomain" code:4 userInfo:@{NSLocalizedDescriptionKey : @"Who you're invited is really a man..."}];
    if(completion) {
        completion(response);
    }
}

@end
