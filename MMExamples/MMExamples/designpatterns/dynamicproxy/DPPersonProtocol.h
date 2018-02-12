//
//  DPPersonProtocol.h
//  MMExamples
//
//  Created by Mark on 2018/2/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#ifndef DPPersonProtocol_h
#define DPPersonProtocol_h

@protocol DPPersonProtocol <NSObject>

+ (void)goDie;
- (void)eat;
- (BOOL)isAGoodGuy;
- (void)buyFish:(NSString *)fishName withMoney:(float)money;
- (void)bathWithCompletion:(void (^)(BOOL successed))completion;

@end

#endif /* DPPersonProtocol_h */
