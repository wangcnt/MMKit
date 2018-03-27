//
//  MMWebView.m
//  MMUIKit
//
//  Created by Mark on 2018/3/27.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMWebView.h"

@implementation MMWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    
    [super loadHTMLString:string baseURL:baseURL];
}

@end
