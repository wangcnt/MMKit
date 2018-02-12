//
//  DPPerson.h
//  MMExamples
//
//  Created by Mark on 2018/2/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DPPersonProtocol.h"

@interface DPPerson : NSObject <DPPersonProtocol>

//- (void)eat;
- (BOOL)isAGoodGuy;
- (void)buyFish:(NSString *)fishName withMoney:(float)money;

@end
