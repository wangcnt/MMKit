//
//  QTWebViewController.h
//  QTime
//
//  Created by Mark on 15/6/16.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "QTViewController.h"

@interface QTWebViewController : QTViewController

@property (nonatomic, assign) NSString *navigationTitle;

- (instancetype)initWithWebsite:(NSString *)website;


@end
