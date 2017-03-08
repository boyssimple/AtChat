//
//  VCRegister.m
//  AtChat
//
//  Created by zhouMR on 16/11/1.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCRegister.h"
#import "VCRegFinish.h"
#import <SMS_SDK/SMSSDK.h>

static NSUInteger showTime = 60;
@interface VCRegister ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *vPhone;
@property (nonatomic, strong) UIView *vPassword;
@property (nonatomic, strong) UIView *vVerticalLine;
@property (nonatomic, strong) UITextField *tfPhone;
@property (nonatomic, strong) UITextField *tfVerify;
@property (nonatomic, strong) UIButton *btnGetVerify;
@property (nonatomic, strong) UIButton *btnNext;
@property (nonatomic, strong) dispatch_source_t timer;

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
    [self hideKeyboard];
    NSString *phone = self.tfPhone.text;
    NSString *message = nil;
    if (phone.length < 11) {
        message = @"请输入手机号码";
    }
    if (message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"发送中...";
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error){
                                         [self hideMsg];
                                         if (!error) {
                                             NSLog(@"获取验证码成功");
                                             [self startTimer];
                                         } else {
                                             NSLog(@"错误信息：%@",error);
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"验证码发送失败！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                                             [alertView show];
                                         }}];
    }
}

- (void)nextAction{
    [self hideKeyboard];
    NSString *phone = self.tfPhone.text;
    NSString *verifyCode = self.tfVerify.text;
    NSString *message = nil;
    if (phone.length < 11) {
        message = @"请输入手机号码";
    }else if (verifyCode.length < 4) {
        message = @"请输入验证码";
    }
    if (message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"验证中...";
        [SMSSDK commitVerificationCode:verifyCode phoneNumber:phone zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
            {
                [self hideMsg];
                if (!error)
                {
                    NSLog(@"验证成功");
                    self.timer = nil;
                    VCRegFinish *vc = [[VCRegFinish alloc]init];
                    vc.phone = phone;
                    [self.navigationController pushViewController:vc animated:TRUE];
                }
                else
                {
                    NSLog(@"错误信息:%@",error);
                    NSString *info = [error.userInfo objectForKey:@"getVerificationCode"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }];
    }
    
}

- (void)startTimer{
    [self setGetVerifyCodeBtn:TRUE];
    __block NSUInteger timeout = showTime;
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timer = timer;
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        //在这里执行事件
        if (timeout <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setGetVerifyCodeBtn:FALSE];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self.btnGetVerify setTitle:[NSString stringWithFormat:@"重(%@s)发",strTime] forState:UIControlStateNormal];
                self.btnGetVerify.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)setGetVerifyCodeBtn:(BOOL)flag{
    if (flag) {
        [self.btnGetVerify setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        self.btnGetVerify.userInteractionEnabled = YES;
        [self.btnGetVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.btnGetVerify setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    }
}


#pragma mark - Getter Setter

- (UIView *)vPhone{
    if (!_vPhone) {
        _vPhone = [[UIView alloc]initWithFrame:CGRectMake(10, 20, DEVICEWIDTH-20, 45)];
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
        _btnGetVerify.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnGetVerify addTarget:self action:@selector(getVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnGetVerify;
}

- (UIView *)vVerticalLine{
    if (!_vVerticalLine) {
        _vVerticalLine = [[UIView alloc]initWithFrame:CGRectMake(self.btnGetVerify.left-10, 5, 1, 35)];
        _vVerticalLine.backgroundColor = BASE_COLOR;
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

- (void)hideMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
