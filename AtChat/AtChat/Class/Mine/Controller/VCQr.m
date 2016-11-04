//
//  VCQr.m
//  LifeChat
//
//  Created by zhouMR on 16/5/10.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "VCQr.h"
#import "HMScannerController.h"

@interface VCQr ()

@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation VCQr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
    [self.view addSubview:self.imageView];
    
    
    
    [HMScannerController cardImageWithCardName:[XmppTools sharedManager].userName avatar:nil scale:0.2 completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

-(UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICEWIDTH-270)/2.0, (DEVICEHEIGHT-270-NAV_STATUS_HEIGHT)/2.0, 270, 270)];
    }
    return _imageView;
}
@end
