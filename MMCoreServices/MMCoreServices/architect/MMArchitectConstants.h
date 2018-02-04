//
//  MMArchitectConstants.h
//  MMCoreServices
//
//  Created by WangQiang on 2018/1/23.
//  Copyright © 2018年 WangQiang. All rights reserved.
//

#ifndef MMArchitectConstants_h
#define MMArchitectConstants_h

#define mm_system_version() [UIDevice currentDevice].systemVersion.floatValue

@protocol MMResponse;

typedef void (^MMRequestCompletion)(id<MMResponse> res);

#endif /* MMArchitectConstants_h */
