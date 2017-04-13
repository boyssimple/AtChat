//
//  VCWeb.m
//  AtChat
//
//  Created by zhouMR on 2017/4/13.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "VCWeb.h"

@interface VCWeb ()
@property (nonatomic, strong) UIWebView *web;
@end

@implementation VCWeb

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.url) {
        _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT-NAV_STATUS_HEIGHT)];
        [_web loadRequest:[[NSURLRequest alloc]initWithURL:self.url]];
        [self.view addSubview:_web];
    }
}


@end
