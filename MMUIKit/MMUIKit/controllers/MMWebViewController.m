//
//  MMWebViewController.m
//  MMime
//
//  Created by Mark on 15/6/16.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMWebViewController.h"

@interface MMWebViewController ()

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *handlersDictionary;

@end

@implementation MMWebViewController

- (instancetype)initWithUrlString:(NSString *)urlString
{
    if(self = [super init])
    {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        _urlString = urlString;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubviews];
    
    if(_urlString)
    {
        NSURL *url = [NSURL URLWithString:_urlString];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [_webView loadRequest:request];
    }
}

- (void)addSubviews
{
    //    window.webkit.messageHandlers.<handlerName>.postMessage(message); js通过这个来传递数据
    
    WKUserContentController *uc = [[WKUserContentController alloc] init];
    
    WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
    configure.userContentController = uc;
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configure];
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    [self.view addSubview:_webView];
}

#pragma mark - <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"did start provisional navigation %@", navigation);
    NSLog(@"2");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"finish navigation %@", navigation);
    
    NSLog(@"4");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"1");
    NSLog(@"decide policy for navigation action %@", navigationAction);
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"decide policy for navigation response %@", navigationResponse);
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    NSLog(@"3");
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([self.handlersDictionary.allKeys containsObject:message.name])
    {
        QTJSBlock block = (QTJSBlock)self.handlersDictionary[message.name];
        
        block(message.body);
    }
}

#pragma mark - 公共方法

- (void)reloadWebWithUrlString:(NSString *)urlString
{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _urlString = urlString;
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [_webView loadRequest:request];
}

- (void)addHandlerWithName:(NSString *)name handler:(QTJSBlock)handler
{
    if (!name.length) return;
    
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:name];
    
    self.handlersDictionary[name] = handler;
}

- (void)removeHandlerWithName:(NSString *)name
{
    if (!name.length) return;
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    
    [self.handlersDictionary removeObjectForKey:name];
}

#pragma mark - Getter Setter

- (NSMutableDictionary<NSString *,id> *)handlersDictionary
{
    if (!_handlersDictionary)
    {
        _handlersDictionary = [NSMutableDictionary dictionary];
    }
    
    return _handlersDictionary;
}

@end
