//
//  MMWebViewController.h
//  MMime
//
//  Created by Mark on 15/6/16.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMViewController.h"

#import <WebKit/WebKit.h>

@class MMWebView;

typedef void(^MMWebViewScriptHandler)(id params);

@interface MMWebViewController : MMViewController <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong, readonly) MMWebView *webView;
@property (nonatomic, strong) NSString *navigationTitle;

- (instancetype)initWithUrlString:(NSString *)urlString;
- (void)reloadWebWithUrlString:(NSString *)urlString;

/**
 *  配置js中可以调用的方法
 *
 *  @param name js调用的名称
 *  @param handler 调用的方法
 */
- (void)addScriptHandlerWithName:(NSString *)name handler:(MMWebViewScriptHandler)handler;
- (void)removeHandlerWithName:(NSString *)name;

@end
