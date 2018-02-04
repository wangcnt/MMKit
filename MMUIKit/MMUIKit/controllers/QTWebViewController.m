//
//  QTWebViewController.m
//  QTime
//
//  Created by Mark on 15/6/16.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "QTWebViewController.h"

@interface QTWebViewController ()
<UIWebViewDelegate>
{
    UIWebView                               *_webView;
}


@property (nonatomic, strong) NSString *website;

@end

@implementation QTWebViewController

- (instancetype)initWithWebsite:(NSString *)website
{
    if(self = [super init])
    {
        _website = website;
    }
    
    return self;
}

- (void)setNavigationItem
{
    [super setNavigationItem];
    
    self.navigationItem.title = _navigationTitle ? _navigationTitle : @"网页";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    _webView.delegate        = self;
    _webView.scalesPageToFit = NO;

    [self.view addSubview:_webView];
    
    
    if(_website)
    {
        NSURL *url = [NSURL URLWithString:_website];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [_webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---------------------------------------------------------------------------------------
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
