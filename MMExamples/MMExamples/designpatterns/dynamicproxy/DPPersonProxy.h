//
//  DPPersonProxy.h
//  MMExamples
//
//  Created by Mark on 2018/2/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DPPersonProtocol.h"

@interface DPPersonProxy : NSProxy <DPPersonProtocol>

- (instancetype)initWithPerson:(id<DPPersonProtocol>)person;

@end
