//
//  UIViewControllerAdditions.m
//  QTTime
//
//  Created by Mark on 15/5/22.
//  Copyright (c) 2015年 Mark. All rights reserved.
//

#import "UIViewControllerAdditions.h"
#import <MessageUI/MessageUI.h>

#import <MMFoundation/MMDefines.h>

__mm_synth_dummy_class__(UIViewControllerAdditions)

@interface UIViewController()
<MFMailComposeViewControllerDelegate>
@end

@implementation UIViewController(Email)

- (void)sendMailToRecipients:(NSArray *)recipients cc:(NSArray *)cc title:(NSString *)subject content:(NSString *)content {
    [self sendMailToRecipients:recipients cc:cc withSubject:subject content:content mimeType:nil fileName:nil data:nil];
}

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)sendMailToRecipients:(NSArray *)recipients cc:(NSArray *)cc withSubject:(NSString *)subject content:(NSString *)content mimeType:(NSString *)mimeType fileName:(NSString *)fileName data:(NSData *)data {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    // must
    controller.subject = subject;
    controller.toRecipients = recipients;
    // should
    if(cc) {
        controller.ccRecipients = cc;
        [controller setMessageBody:content isHTML:NO];
        if(mimeType && data && fileName) {
            [controller addAttachmentData:data mimeType:mimeType fileName:fileName];
        }
    }
    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled: {
            NSLog(@"Result: canceled");
            break;
        } case MFMailComposeResultSaved: {
            NSLog(@"Result: saved");
            break;
        } case MFMailComposeResultSent: {
            NSLog(@"Result: sent");
            break;
        } case MFMailComposeResultFailed: {
            NSLog(@"Result: failed");
            break;
        } default: {
            NSLog(@"Result: not sent");
            break;
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end

