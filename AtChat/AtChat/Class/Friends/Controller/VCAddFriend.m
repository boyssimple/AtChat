//
//  VCAddFriend.m
//  LifeChat
//
//  Created by zhouMR on 16/5/10.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "VCAddFriend.h"

@interface VCAddFriend ()
@property(nonatomic,strong)UILabel *lbName;
@property(nonatomic,strong)UITextField *tfText;
@property(nonatomic,strong)UIButton *btnAdd;
@end

@implementation VCAddFriend

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.lbName];
    [self.view addSubview:self.tfText];
    [self.view addSubview:self.btnAdd];
    if (self.paramsUser) {
        self.tfText.text = self.paramsUser;
    }
}

#pragma  mark - geter seter
- (UILabel*)lbName{
    if (!_lbName) {
        _lbName = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 45, 15)];
        _lbName.text = @"帐号：";
        _lbName.font = [UIFont systemFontOfSize:14];
    }
    return _lbName;
}

- (UITextField*)tfText{
    if (!_tfText) {
        _tfText = [[UITextField alloc]initWithFrame:CGRectMake(self.lbName.right+10, 42, DEVICEWIDTH-self.lbName.right-20, 30)];
        _tfText.placeholder = @" 好友帐号";
        _tfText.layer.borderColor = RGB(189, 189, 189).CGColor;
        _tfText.layer.borderWidth = 0.5;
        _tfText.layer.cornerRadius = 5;
        _tfText.font = [UIFont systemFontOfSize:14];
    }
    return _tfText;
}

- (UIButton*)btnAdd{
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc]initWithFrame:CGRectMake(10, self.lbName.bottom+30, DEVICEWIDTH-20, 40)];
        
        [_btnAdd setBackgroundColor:BASE_COLOR];
        [_btnAdd setTitle:@"添加好友" forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        _btnAdd.layer.cornerRadius = 5;
    }
    return _btnAdd;
}

-(void)addAction{
    [self hideKeyBoard];
    NSString *username = self.tfText.text;
    if(username.length <= 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"帐号不能为空" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"请稍等...";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[XmppTools sharedManager]addFriendById:username];
        });
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyBoard];
}

-(void)hideKeyBoard{
    [self.tfText resignFirstResponder];
}
@end
