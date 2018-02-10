//
//  MMTranslucentViewController.m
//  QTime
//
//  Created by mima on 15/11/27.
//  Copyright © 2015年 Mark. All rights reserved.
//  在present 或者 push 此controller时, 系统不会清理在本controller之前的view, 即可达到透视到下层view的效果

#import "MMTranslucentViewController.h"

@interface MMTranslucentViewController() {
    UIControl   *_backgroundControl;    /// 如果是模态弹出的话，需要加上此control
}

@end

@implementation MMTranslucentViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [UIApplication sharedApplication].keyWindow.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self addSubviewsIfNeeds];
}

- (void)addSubviewsIfNeeds {
    if(_modalize) {
        if(!_backgroundControl) {
            _backgroundControl = [[UIControl alloc] initWithFrame:self.view.bounds];
            [_backgroundControl addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
            [self.view insertSubview:_backgroundControl atIndex:0];
        }
    }
}

- (void)dismiss {
    if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:self completion:nil];
    }
}

@end
