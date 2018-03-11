//
//  MMTextView.m
//  MMime
//
//  Created by Mark on 15/6/30.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "MMTextView.h"

@interface MMTextView()

@property(nonatomic, strong, readonly)  UILabel *placeholderLabel;
@property(nonatomic, assign) float placeholderWidth;

@end

@implementation MMTextView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginNoti:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEndNoti:) name:UITextViewTextDidEndEditingNotification object:self];
        
        [self defaultConfig];
        
        // placeholder view
        float height = 30;
        _placeholderWidth = CGRectGetWidth(self.frame) - 2*_placeholderOffset.x;
        CGRect frame = CGRectMake(_placeholderOffset.x, _placeholderOffset.y,
                                  _placeholderWidth, height);
        _placeholderLabel = [[UILabel alloc] initWithFrame:frame];
        _placeholderLabel.textColor = _placeholderColor;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.lineBreakMode = NSLineBreakByCharWrapping|NSLineBreakByWordWrapping;
        [self addSubview:_placeholderLabel];
    }
    return self;
}

- (void)layoutSubviews {
    float height = self.bounds.size.height;
    _placeholderWidth = CGRectGetWidth(self.frame)-2*_placeholderOffset.x;
    
    CGRect frame = _placeholderLabel.frame;
    frame.origin.x    = _placeholderOffset.x;
    frame.origin.y    = _placeholderOffset.y;
    frame.size.width  = _placeholderWidth;
    frame.size.height = height;
    _placeholderLabel.frame = frame;
    
    [_placeholderLabel sizeToFit];
}

- (void)dealloc {
    [_placeholderLabel removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)defaultConfig {
    _maxLength = 1000;
    self.placeholderColor = [UIColor lightGrayColor];
    self.placeholderFont = [UIFont systemFontOfSize:14];
    self.placeholderOffset = CGPointMake(5, 6);
    self.layoutManager.allowsNonContiguousLayout = NO;
}

 //供外部使用的 api
- (void)setPlaceholderOpacity:(float)opacity {
    if (opacity < 0) {
        opacity=1;
    }
    self.placeholderLabel.layer.opacity=opacity;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if(_placeholderColor != placeholderColor) {
        _placeholderColor = placeholderColor;
        _placeholderLabel.textColor = _placeholderColor;
    }
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    if (placeholderFont) {
        _placeholderFont = placeholderFont;
        _placeholderLabel.font = placeholderFont;
    }
}
#pragma mark - Noti Event
- (void)textViewBeginNoti:(NSNotification*)notification {
}

- (void)textViewEndNoti:(NSNotification*)notification {
}

- (void)textDidChange:(NSNotification*)notification {
    if(notification.object != self) return;
    
    _placeholderLabel.hidden = self.text.length;
    NSString *text = self.text;
    //获取高亮部分
    UITextRange *markedRange = self.markedTextRange;
    UITextPosition *position = [self positionFromPosition:markedRange.start offset:0];
    
    if ( (!position ||!markedRange)
        && (_maxLength && text.length > _maxLength)) {
        NSRange rangeIndex = [text rangeOfComposedCharacterSequenceAtIndex:_maxLength];
        if (rangeIndex.length == 1) {
            self.text = [text substringToIndex:_maxLength];
        } else {
            NSRange range = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxLength)];
            NSInteger length;
            if (range.length > _maxLength) {
                length = range.length - rangeIndex.length;
            }else{
                length = range.length;
            }
            self.text = [text substringWithRange:NSMakeRange(0, length)];
        }
        if(_textDidChangeHandler) {
            _textDidChangeHandler(self);
        }
    }
}

#pragma mark - private method

+ (float)boundingRectWithSize:(CGSize)size withLabel:(NSString *)label withFont:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    // CGSize retSize;
    CGSize retSize = [label boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    return retSize.height;
}

#pragma mark - getters and Setters

- (void)setText:(NSString *)tex {
    _placeholderLabel.hidden = tex.length;
    [super setText:tex];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if(_placeholder != placeholder) {
        _placeholder = placeholder;
        _placeholderLabel.hidden = !placeholder.length;
        _placeholderLabel.text = placeholder;
    }
}

@end
