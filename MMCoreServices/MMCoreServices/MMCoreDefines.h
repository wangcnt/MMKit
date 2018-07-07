//
//  MMCoreServicesConstants.h
//  MMCoreServices
//
//  Created by Mark on 2018/1/23.
//  Copyright © 2018年 Mark. All rights reserved.
//

#ifndef MMCoreDefines_h
#define MMCoreDefines_h

#define MMCORESERVICES_EXPORT extern

@protocol MMResponse;

typedef void (^MMRequestProgressHandler)(float progress);
typedef void (^MMRequestCompletion)(id<MMResponse> res);

typedef NS_ENUM(NSInteger, MMCoreServicesErrorCode) {
    MMCoreServicesErrorCodeInvalidService,
    MMCoreServicesErrorCodeOperationCancelled,
    MMCoreServicesErrorCodeException,
    MMCoreServicesErrorCodeRequestCancelled
};

typedef NS_ENUM(NSInteger, MMRequestStep) {
    MMRequestStepWaiting,      ///< 正在等待任務開始...
    MMRequestStepPreparing,    ///< 等待發送請求...
    MMRequestStepReceiving,    ///< 正在接收數據
    MMRequestStepParsing,      ///< 正在解析數據
    MMRequestStepPersisting,   ///< 正在將數據寫入本地...
    MMRequestStepFinished      ///< 任務完成
};

FOUNDATION_STATIC_INLINE NSString *mm_default_step_name_with_step_cn(MMRequestStep step) {
    if(step < MMRequestStepWaiting || step > MMRequestStepFinished) {
        return @"";
    }
    return @[@"正在等待任務開始...",
             @"正在發送請求...",
             @"正在接收數據...",
             @"正在解析數據...",
             @"正在將數據寫入本地...",
             @"任務完成."][step];
}

FOUNDATION_STATIC_INLINE NSString *mm_default_step_name_with_step_en(MMRequestStep step) {
    if(step < MMRequestStepWaiting || step > MMRequestStepFinished) {
        return @"";
    }
    return @[@"Waiting...",
             @"Sending...",
             @"Receiving...",
             @"Parsing...",
             @"Persisting...",
             @"Completed."][step];
}

FOUNDATION_STATIC_INLINE NSString *mm_default_step_name_with_step(MMRequestStep step) {
    return mm_default_step_name_with_step_en(step);
}

typedef void (^MMRequestStepHandler)(MMRequestStep step);

#endif /* MMCoreDefines_h */
