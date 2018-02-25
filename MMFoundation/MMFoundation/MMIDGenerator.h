//
//  MMIDGenerator.h
//  MMFoundation
//
//  Created by Mark on 2018/2/26.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMIDGenerator <NSObject>

@optional
@property (nonatomic, strong) NSString *prefix;

@required
- (NSString *)nextID;

@end

@interface MMDefaultIDGenerator : NSObject <MMIDGenerator>
@property (nonatomic, strong) NSString *prefix;
- (NSString *)nextID;   ///< Format: prefix.1/2/3/4/5...
@end
