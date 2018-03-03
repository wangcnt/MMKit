//
//  QTHomepageViewController.m
//  QTimeUI
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "QTHomepageViewController.h"

#import <QTimeFoundation/QTimeFoundation.h>
#import <MMUIKit/MMUIKit.h>
#import <Masonry/Masonry.h>
#import "QTServiceCenter.h"

@interface QTHomepageViewController ()
@property (nonatomic, strong) MMButton *button;
@property (nonatomic, strong) MMLabel *messageLabel;
@end

@implementation QTHomepageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // invite button
    UIImage *image = [UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(10, 10)];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    _button = [[MMButton alloc] init];
    _button.layer.cornerRadius = 4;
    _button.layer.masksToBounds = YES;
    _button.eventableInset = UIEdgeInsetsMake(-50, -50, -50, -50);
    [_button setBackgroundImage:image forState:UIControlStateNormal];
    [_button setTitle:@"Invite" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_button.superview);
        make.top.mas_equalTo(250);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    _messageLabel = [[MMLabel alloc] init];
    _messageLabel.backgroundColor = [UIColor greenColor];
    _messageLabel.textColor = [UIColor purpleColor];
    [self.view addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_button.mas_bottom).offset(30);
        make.centerX.mas_equalTo(_button.superview);
    }];
    [self updateLabelWithText:@"Click button to invite."];
}

- (void)updateLabelWithText:(NSString *)text {
    _messageLabel.text = text;
    [_messageLabel sizeToFit];
    CGSize size = _messageLabel.frame.size;
    [_messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}

- (void)invite:(id)sender {
    [self updateLabelWithText:@"Inviting..."];
    [[QTServiceCenter sharedInstance] inviteTheGirlWithName:@"Ning ning" step:^(MMRequestStep step) {
        [self updateLabelWithText:mm_default_step_name_with_step(step)];
    } completion:^(NSError *error) {
        NSString *text = error ? error.localizedDescription : @"Bingo!";
        [self updateLabelWithText:text];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
