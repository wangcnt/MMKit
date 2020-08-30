//
//  MMDetectFaceViewController.m
//  MMSamples
//
//  Created by Mark on 2020/7/12.
//  Copyright © 2020 Mark. All rights reserved.
//

#import "MMDetectFaceViewController.h"

#import <Vision/Vision.h>

@interface MMDetectFaceViewController ()

@end

@implementation MMDetectFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [UIImage imageNamed:@"laoganma"];
    UIImageView *imageView = [[UIImageView alloc] init];
    float imageWidth = img.size.width;
    float imageHeight = img.size.height;
    float width = MIN(imageWidth, self.view.frame.size.width);
    float height = imageHeight * width / imageWidth;
    imageView.frame = CGRectMake(0, 200, width, height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = img;
    [self.view addSubview:imageView];
    UIView *resultView = [[UIView alloc] initWithFrame:imageView.frame];
    [self.view addSubview:resultView];
    
    if(@available(iOS 11.0, *)) {
        // CIImage
        CIImage *convertImage = [CIImage imageWithCGImage:img.CGImage];
        // 创建处理requestHandler
        VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
        // 创建BaseRequest
        VNImageBasedRequest *request = [[VNDetectFaceRectanglesRequest alloc]initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            NSArray *observations = request.results;
            
            // 得到Observation
            VNFaceObservation *faceObservation = observations.firstObject;
            
            CGRect rect = faceObservation.boundingBox; //返回识别区域的比例值
            
            CGFloat X = rect.origin.x * img.size.width;
            CGFloat W = rect.size.width * img.size.width;
            CGFloat H = rect.size.height * img.size.height;
            CGFloat Y = img.size.height * (1 - rect.origin.y) - H; // Y比例值是距离底部的
            UIView *faceView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
            faceView.layer.borderColor = [UIColor redColor].CGColor;
            faceView.layer.borderWidth = 1;
            [resultView addSubview:faceView];
        }];
        // 发送识别请求
        [handler performRequests:@[request] error:nil];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
