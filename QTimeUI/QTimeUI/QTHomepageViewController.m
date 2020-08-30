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

@interface QTHomepageViewController ()
<UIContextMenuInteractionDelegate>

@property (nonatomic, strong) MMButton *button;
@property (nonatomic, strong) MMLabel *messageLabel;
@end

@implementation QTHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // invite button
    [self addInviteButton];
    
    // info label
    [self addMessageLabel];
    [self updateLabelWithText:@"Click invite button to invite."];
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    
    // constraints
    [self addConstraints];
}

- (void)addInviteButton {
    UIImage *image = [UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(10, 10)];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    _button = [[MMButton alloc] init];
    _button.layer.cornerRadius = 4;
    _button.layer.masksToBounds = YES;
    _button.titleLabel.font = [UIFont systemFontOfSize:19];
    _button.eventableInset = UIEdgeInsetsMake(-50, -50, -50, -50);
    [_button setBackgroundImage:image forState:UIControlStateNormal];
    [_button setTitle:@"Invite" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 13.0, *)) {
        UIContextMenuInteraction *interction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
        [_button addInteraction:interction];
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_button];
}

- (void)addMessageLabel {
    _messageLabel = [[MMLabel alloc] init];
    _messageLabel.backgroundColor = [UIColor greenColor];
    _messageLabel.textColor = [UIColor purpleColor];
    _messageLabel.font = [UIFont systemFontOfSize:17];
    _messageLabel.layer.cornerRadius = 4;
    _messageLabel.layer.masksToBounds = YES;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messageLabel];
}

- (void)addConstraints {
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_button.superview);
        make.top.mas_equalTo(250);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_button.mas_bottom).offset(MAX(30, fabs(_button.eventableInset.bottom)));
        make.centerX.mas_equalTo(_button.superview);
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(200);
    }];
}

- (void)updateConstraints {
    
}

- (void)updateLabelWithText:(NSString *)text {
    _messageLabel.text = text;
//    [_messageLabel sizeToFit];
//    CGSize size = _messageLabel.frame.size;
//    size.width += 20;
//    size.height += 10;
//    [_messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(size);
//    }];
}

- (void)invite:(id)sender {    
//    QTHomepageViewController *controller = [[QTHomepageViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
    
    _button.enabled = NO;
    [[QTServiceCenter sharedInstance] inviteTheGirlWithName:@"Ning ning" step:^(MMRequestStep step) {
        if(step != MMRequestStepFinished) {
            [self updateLabelWithText:mm_default_step_name_with_step(step)];
        }
    } completion:^(NSError *error) {
        NSString *text = error ? error.localizedDescription : @"Bingo!";
        [self updateLabelWithText:text];
        _button.enabled = YES;
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

- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location  API_AVAILABLE(ios(13.0)){
    return [UIContextMenuConfiguration configurationWithIdentifier:@"So" previewProvider:^UIViewController * _Nullable{
        return [[QTHomepageViewController alloc] init];
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        UIAction *sayHelloAction = [UIAction actionWithTitle:@"Hello, world!" image:[UIImage imageNamed:@"laoganma"] identifier:@"sayHelloAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Hello, world!");
        }];
        
        UIAction *copyAction = [UIAction actionWithTitle:@"Copy" image:[UIImage systemImageNamed:@"pencil.and.outline"] identifier:@"copyAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Copying.....");
        }];
        
        UIAction *cutAction = [UIAction actionWithTitle:@"Cut" image:[UIImage removeImage] identifier:@"removeAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Cutting.....");
        }];
        
        UIAction *pasteAction = [UIAction actionWithTitle:@"Paste" image:[UIImage addImage] identifier:@"addAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"Pasting.....");
        }];
        
        UIAction *selectAction = [UIAction actionWithTitle:@"Select" image:[UIImage checkmarkImage] identifier:@"selectAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"selecting.....");
        }];
        
        UIAction *selectAllAction = [UIAction actionWithTitle:@"Select All" image:[UIImage strokedCheckmarkImage] identifier:@"selectAllAction" handler:^(__kindof UIAction * _Nonnull action) {
            NSLog(@"selecting all.....");
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:@"I'm a menu." image:[UIImage checkmarkImage] identifier:@"" options:UIMenuOptionsDisplayInline children:@[sayHelloAction, copyAction, cutAction, pasteAction, selectAction, selectAllAction]];
        
        return menu;
    }];
}

@end
