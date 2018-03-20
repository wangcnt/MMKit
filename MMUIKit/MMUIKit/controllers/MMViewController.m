//
//  MMViewController.h
//  MMTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMViewController.h"
#import <MMLog/MMLog.h>

@interface MMViewController ()

@end

@implementation MMViewController

- (instancetype)init {
    if(self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
}

- (void)setNavigationItem {
}

- (void)setNavigationWithTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void)dealloc {
    MMLogInfo(@"deallocated[%@]", NSStringFromClass(self.class));
}

@end




