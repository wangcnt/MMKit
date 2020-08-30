//
//  SecondViewController.m
//  MMSamples
//
//  Created by Mark on 2018/3/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "SecondViewController.h"

#import "SampleAppDelegate.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"First";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SampleAppDelegate *appDelegate = (SampleAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate showLaunchOptions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
