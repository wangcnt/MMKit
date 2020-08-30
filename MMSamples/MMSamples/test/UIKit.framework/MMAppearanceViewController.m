//
//  MMAppearanceViewController.m
//  MMSamples
//
//  Created by Mark on 2020/7/18.
//  Copyright © 2020 Mark. All rights reserved.
//

#import "MMAppearanceViewController.h"
#import <MMUIKit/UIColorAdditions.h>

@interface UILabel (FontAppearance)
@property (nonatomic, strong) UIColor *appearancingTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *appearanceFont UI_APPEARANCE_SELECTOR;
@end

@implementation UILabel (FontAppearance)

- (void)setAppearanceFont:(UIFont *)font {
    if (font) {
        self.font = font;
    }
}

- (UIFont *)appearanceFont {
    return self.font;
}

- (void)setAppearancingTextColor:(UIColor *)appearancingTextColor {
    if(appearancingTextColor) {
        self.textColor = appearancingTextColor;
    }
}

- (UIColor *)appearancingTextColor {
    return self.textColor;
}

@end


@interface MMAppearanceViewController ()

@end

@implementation MMAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UILabel *label = [UILabel appearanceWhenContainedInInstancesOfClasses:@[UIAlertController.class]];
//    label.appearanceFont = [UIFont systemFontOfSize:10];

//    label.appearancingTextColor = [UIColor magentaColor];
    [UIColor colorWithAnyModeColor:[UIColor magentaColor] darkModeColor:[UIColor redColor]];
    
    [self present];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)present{
    NSString *title = @"选择问题类型";
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //    UIColor *titleColor = [UIColor colorWithAnyModeColor:HEXA(0x232F40, 1) darkModeColor:HEXA(0xD5DEE6, 1)];
    //    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : titleColor}];
    //    [controller setValue:attributedTitle forKey:@"attributedTitle"];
    
    UIColor *actionColor = [UIColor colorWithAnyModeColor:[UIColor colorWithHex:0x9AA7B3] darkModeColor:[UIColor colorWithHex:0x596980]];
    NSString *accountTitle = @"账号或者密码相关问题";
    UIAlertAction *accountAction = [UIAlertAction actionWithTitle:accountTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //    [accountAction setValue:actionColor forKey:@"titleTextColor"];
    [controller addAction:accountAction];
    
    NSString *tradeTitle = @"合约交易相关问题";
    UIAlertAction *tradeAction = [UIAlertAction actionWithTitle:tradeTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //    [tradeAction setValue:actionColor forKey:@"titleTextColor"];
    [controller addAction:tradeAction];
    
    NSString *coinTitle = @"充币或提币相关问题";
    UIAlertAction *coinAction = [UIAlertAction actionWithTitle:coinTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //    [coinAction setValue:actionColor forKey:@"titleTextColor"];
    [controller addAction:coinAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancelAction setValue:actionColor forKey:@"titleTextColor"];
    [controller addAction:cancelAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
