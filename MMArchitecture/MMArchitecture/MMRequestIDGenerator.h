//
//  MMRequestIDGenerator.h
//  MMArchitecture
//
//  Created by Mark on 2018/2/25.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMFoundation/MMIDGenerator.h>

@protocol MMRequestIDGenerator <NSObject, MMIDGenerator>
@end

@interface MMDefaultRequestIDGenerator : MMDefaultIDGenerator <MMRequestIDGenerator>
@end
