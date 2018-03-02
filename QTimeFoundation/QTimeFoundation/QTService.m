//
//  QTService.m
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTService.h"

@implementation QTService



- (void)inviteTheGirlWithName:(NSString *)name completion:(void (^)(NSError *error))completion {
    if(completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = arc4random() % 2 ? nil : [NSError errorWithDomain:@"QTServiceErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey : @"Your target is really a man."}];
            completion(error);
        });
    }
}

@end
