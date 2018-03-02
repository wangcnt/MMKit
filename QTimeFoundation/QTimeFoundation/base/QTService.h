//
//  QTService.h
//  QTimeFoundation
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <MMArchitecture/MMArchitecture.h>

@protocol QTService <MMService>

- (void)inviteTheGirlWithName:(NSString *)name completion:(void (^)(NSError *error))completion;

@end

@interface QTService : MMService <QTService>
@end
