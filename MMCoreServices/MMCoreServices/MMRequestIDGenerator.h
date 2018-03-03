//
//  MMRequestIDGenerator.h
//  MMCoreServices
//
//  Created by Mark on 2018/2/25.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMFoundation/MMIDGenerator.h>

@protocol MMRequestIDGenerator <MMIDGenerator>
@end

@interface MMDefaultRequestIDGenerator : MMDefaultIDGenerator <MMRequestIDGenerator>
@end
