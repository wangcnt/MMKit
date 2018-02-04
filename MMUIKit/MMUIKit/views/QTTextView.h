//
//  QTTextView.h
//  QTime
//
//  Created by Mark on 15/6/30.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTTextView;

typedef void (^QTTextViewDidChangeTextHandler)(QTTextView *textView);

@interface QTTextView : UITextView

@property (nonatomic, copy)   NSString  *placeholder;

@property (nonatomic, strong) UIFont    *placeholderFont;

@property (nonatomic, strong) UIColor   *placeholderColor;

@property (nonatomic, assign) float      placeholderOpacity;

@property (nonatomic, assign) CGPoint    placeholderOffset;

//最大长度设置
@property(nonatomic, assign) NSInteger   maxLength;

@property (nonatomic, strong) QTTextViewDidChangeTextHandler textDidChangeHandler;

@end
