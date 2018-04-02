//
//  MMWebViewController.m
//  MMime
//
//  Created by Mark on 15/6/16.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMWebViewController.h"
#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>
#import <MMFoundation/NSStringAdditions.h>
#import "MMWebView.h"

@interface MMWebViewController ()

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *handlersDictionary;

@end

@implementation MMWebViewController

- (instancetype)initWithUrlString:(NSString *)urlString {
    if(self = [super init]) {
        _urlString = [urlString stringByURLEncoding];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    if(_urlString) {
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
}

- (void)addSubviews {
//    window.webkit.messageHandlers.<handlerName>.postMessage(message); js通过这个来传递数据
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = controller;
    _webView = [[MMWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
        if(@available(iOS 11.0, *)) {
            inset = self.view.safeAreaInsets;
        }
#endif
        make.edges.mas_equalTo(inset);
    }];
}

#pragma mark - <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"did start provisional navigation %@", navigation);
    NSLog(@"2");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"finish navigation %@", navigation);
    NSLog(@"4");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"1");
    NSLog(@"decide policy for navigation action %@", navigationAction);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decide policy for navigation response %@", navigationResponse);
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"3");
}

#pragma mark -------------------------------------------------------------------
#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.handlersDictionary.allKeys containsObject:message.name]) {
        MMWebViewScriptHandler block = (MMWebViewScriptHandler)self.handlersDictionary[message.name];
        block(message.body);
    }
}

#pragma mark - 公共方法

- (void)reloadWebWithUrlString:(NSString *)urlString {
    _urlString = [urlString stringByURLEncoding];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [_webView loadRequest:request];
}

- (void)addScriptHandlerWithName:(NSString *)name handler:(MMWebViewScriptHandler)handler {
    if (!name.length || !handler) return;
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:name];
    self.handlersDictionary[name] = handler;
}

- (void)removeHandlerWithName:(NSString *)name {
    if (!name.length) return;
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    [self.handlersDictionary removeObjectForKey:name];
}

#pragma mark -------------------------------------------------------------------
#pragma mark getters & setters
- (NSMutableDictionary<NSString *,id> *)handlersDictionary {
    if (!_handlersDictionary) {
        _handlersDictionary = [NSMutableDictionary dictionary];
    }
    return _handlersDictionary;
}

@end
