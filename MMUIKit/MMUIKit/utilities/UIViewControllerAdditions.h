//
//  UIViewControllerAdditions.h
//  QTTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UINavigationControllerAdditions.h"

@interface UIViewController(Email)

- (void)sendMailToRecipients:(NSArray *)recipients cc:(NSArray *)cc title:(NSString *)subject content:(NSString *)content;

-(void)sendMailToRecipients:(NSArray *)recipients cc:(NSArray *)cc withSubject:(NSString *)subject content:(NSString *)content mimeType:(NSString *)mimeType fileName:(NSString *)fileName data:(NSData *)data;

@end

@interface UIViewController(SMS)

@end
