//
//  VCRegister.m
//  AtChat
//
//  Created by zhouMR on 16/11/1.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCRegister.h"

@interface VCRegister ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *vPhone;
@property (nonatomic, strong) UIView *vPassword;
@property (nonatomic, strong) UIView *vVerticalLine;
@property (nonatomic, strong) UITextField *tfPhone;
@property (nonatomic, strong) UITextField *tfVerify;
@property (nonatomic, strong) UIButton *btnGetVerify;
@property (nonatomic, strong) UIButton *btnNext;

@end

@implementation VCRegister


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self initUI];
}

- (void)initUI{
    [self.view addSubview:self.vPhone];
    [self.view addSubview:self.vPassword];
    [self.view addSubview:self.btnNext];
}


#pragma mark - Event
- (void)getVerifyAction{

}

- (void)nextAction{
    
}


#pragma mark - Getter Setter

- (UIView *)vPhone{
    if (!_vPhone) {
        _vPhone = [[UIView alloc]initWithFrame:CGRectMake(10, 20+NAV_STATUS_HEIGHT, DEVICEWIDTH-20, 45)];
        _vPhone.layer.borderColor = BASE_COLOR.CGColor;
        _vPhone.layer.borderWidth = 1;
        _vPhone.layer.cornerRadius = 5;
        _vPhone.layer.masksToBounds = YES;
        [_vPhone addSubview:self.tfPhone];
    }
    return _vPhone;
}

- (UIView *)vPassword{
    if (!_vPassword) {
        _vPassword = [[UIView alloc]initWithFrame:CGRectMake(10, self.vPhone.bottom+10, DEVICEWIDTH-20, 45)];
        _vPassword.layer.borderColor = BASE_COLOR.CGColor;
        _vPassword.layer.borderWidth = 1;
        _vPassword.layer.cornerRadius = 5;
        _vPassword.layer.masksToBounds = YES;
        [_vPassword addSubview:self.tfVerify];
        [_vPassword addSubview:self.btnGetVerify];
        [_vPassword addSubview:self.vVerticalLine];
    }
    return _vPassword;
}


- (UITextField *)tfPhone{
    if (!_tfPhone) {
        _tfPhone = [[UITextField alloc]initWithFrame:CGRectMake(10, 2.5, DEVICEWIDTH-40, 40)];
        _tfPhone.placeholder = @"手机号码";
        _tfPhone.delegate = self;
    }
    return _tfPhone;
}


- (UITextField *)tfVerify{
    if (!_tfVerify) {
        _tfVerify = [[UITextField alloc]initWithFrame:CGRectMake(10, 2.5, DEVICEWIDTH-160, 40)];
        _tfVerify.placeholder = @"验证码";
        _tfVerify.delegate = self;
    }
    return _tfVerify;
}


- (UIButton*)btnGetVerify{
    if (!_btnGetVerify) {
        _btnGetVerify = [[UIButton alloc]initWithFrame:CGRectMake(self.tfVerify.right+20, self.tfVerify.top, 100, 40)];
        [_btnGetVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnGetVerify setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [_btnGetVerify addTarget:self action:@selector(getVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnGetVerify;
}

- (UIView *)vVerticalLine{
    if (!_vVerticalLine) {
        _vVerticalLine = [[UIView alloc]initWithFrame:CGRectMake(self.btnGetVerify.left, self.tfVerify.top, 1, 40)];
        _vVerticalLine.backgroundColor = [UIColor grayColor];
    }
    return _vVerticalLine;
}

- (UIButton*)btnNext{
    if (!_btnNext) {
        _btnNext = [[UIButton alloc]initWithFrame:CGRectMake(10, self.vPassword.bottom+10, DEVICEWIDTH-20, 45)];
        _btnNext.backgroundColor = BASE_COLOR;
        [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
        [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnNext.layer.cornerRadius = 5;
        _btnNext.layer.masksToBounds = YES;
        [_btnNext addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNext;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}

- (void)hideKeyboard{
    [self.tfPhone resignFirstResponder];
    [self.tfVerify resignFirstResponder];
}
@end
