//
//  QTNonetworkingView.h
//  QTUIKit
//
//  Created by Mark on 15/12/16.
//  Copyright © 2015年 Mark. All rights reserved.
//

#import <QTUIKit/QTUIKit.h>

@protocol QTNonetworkingViewDelegate;

@interface QTNonetworkingView : QTView

@property (nonatomic, weak) id<QTNonetworkingViewDelegate> delegate;

@end



@protocol QTNonetworkingViewDelegate <NSObject>

- (void)nonetworkingViewNeedsReloading:(QTNonetworkingView *)view;

@end
