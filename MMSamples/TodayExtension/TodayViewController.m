//
//  TodayViewController.m
//  TodayExtension
//
//  Created by Mark on 2020/7/12.
//  Copyright © 2020 Mark. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <Masonry/Masonry.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mark.mmsample"];
    NSString *value = [userDefaults objectForKey:@"key"];
    NSLog(@"");
    
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 20, 0, 20);
    CGRect frame;
    frame.origin.x = insets.left;
    frame.origin.y = insets.top;
    frame.size.width = self.view.frame.size.width - insets.left - insets.right;
    frame.size.height = 25;
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = value;
    label.textColor = [UIColor systemRedColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.left.mas_equalTo(40);
//        make.right.mas_equalTo(-40);
//        make.height.mas_equalTo(25);
//    }];
    
    frame.origin.y = label.frame.origin.y + label.frame.size.height + 20;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 3;
    [button setTitle:@"Go" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonTapped:(UIButton *)button {
    NSURL *URL = [NSURL URLWithString:@"mmsamplescheme://com.mark.mmsample/go"];
    [self.extensionContext openURL:URL completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
