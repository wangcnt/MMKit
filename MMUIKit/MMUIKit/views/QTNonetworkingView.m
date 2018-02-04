//
//  QTNonetworkingView.m
//  QTUIKit
//
//  Created by Mark on 15/12/16.
//  Copyright © 2015年 Mark. All rights reserved.
//

#import "QTNonetworkingView.h"

#import "UIViewAdditions.h"

@interface QTNonetworkingView()
{
    UIImageView         *_imageView;
    
    UILabel             *_tipLabel;
    
    UIButton            *_reloadButton;
}

@end

@implementation QTNonetworkingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addSubviews];
    }
    
    return self;
}

- (void)addSubviews
{
    // imageView
    {
        UIImage *image = [UIImage imageNamed:@"p_ico_wwl"];
        CGRect rect = CGRectMake((self.width - image.size.width) / 2, 0, image.size.width, image.size.height);
        
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        
        _imageView.image = image;
        
        [self addSubview:_imageView];
    }
    
    // _tipLabel
    {
        CGRect rect = CGRectMake(0, _imageView.maxY + 10, self.width, 35);
        
        _tipLabel = [[UILabel alloc] initWithFrame:rect];
        
        _tipLabel.textColor     = [UIColor colorWithRed:136.0/255 green:136.0/255 blue:136.0/255 alpha:1];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        
        [self addSubview:_tipLabel];
        
        {
            NSString *keyword = @"点击按钮重新加载";
            NSString *tip = @"网络请求失败";
            
            NSRange range = [tip rangeOfString:keyword];
            
            NSMutableAttributedString *attributedTip = [[NSMutableAttributedString alloc] initWithString:tip];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            paragraphStyle.lineSpacing = 8;
            [attributedTip addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, tip.length)];
            
            [attributedTip addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.5] range:range];
            [attributedTip addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1]
                                  range:range];
            
//            _tipLabel.attributedText = attributedTip;
            
            _tipLabel.text = tip;
        }
    }
    
    // _reloadButton
    {
        float width = 120;
        CGRect rect = CGRectMake((self.width - width) / 2, _tipLabel.maxY + 15, width, 44);
        
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _reloadButton.frame = rect;
        _reloadButton.layer.borderColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
        _reloadButton.layer.borderWidth = 2;
        _reloadButton.layer.cornerRadius = _reloadButton.height / 2;
        
        _reloadButton.backgroundColor = [UIColor whiteColor];
        
        [_reloadButton setTitleColor:[UIColor colorWithRed:136.0/255 green:136.0/255 blue:136.0/255 alpha:1]
                            forState:UIControlStateNormal];
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        
        [_reloadButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_reloadButton];
    }
    
    CGRect rect = self.frame;
    rect.size.height = _reloadButton.maxY - _imageView.y;
    
    self.frame = rect;
}

- (void)buttonTapped:(UIButton *)button
{
    if(_delegate && [_delegate respondsToSelector:@selector(nonetworkingViewNeedsReloading:)])
    {
        [_delegate nonetworkingViewNeedsReloading:self];
    }
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    return hitView==self ? nil : hitView;
}

@end
