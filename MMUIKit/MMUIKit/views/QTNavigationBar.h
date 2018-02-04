//
//  QTNavigationBar.h
//
//  Created by Corey Roberts on 9/24/13.
//  Copyright (c) 2013 SpacePyro Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTNavigationBar : UINavigationBar

/**
 *  Change blur color
 *
 */
- (void)blurWithColor:(UIColor *)color;
/**
 *  Specify an image to customize blur effect
 *
 */
- (void)blurWithImage:(UIImage *)image;

@end
