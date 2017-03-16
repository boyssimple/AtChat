//
//  VCForgotPwd.m
//  AtChat
//
//  Created by zhouMR on 2017/3/16.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "VCForgotPwd.h"

@interface VCForgotPwd ()

@end

@implementation VCForgotPwd

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[XmppTools sharedManager] changePassworduseWord:@"12345678" withUser:@"15909217516"];
}


@end
