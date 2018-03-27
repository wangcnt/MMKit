//
//  MMWebView.m
//  MMUIKit
//
//  Created by Mark on 2018/3/27.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MMWebView.h"
#import <MMFoundation/NSStringAdditions.h>

@implementation MMWebView

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    NSMutableString *html = [string mutableCopy];
    [html deleteEmptyTitle];
    return [super loadHTMLString:html baseURL:baseURL];
}

@end
