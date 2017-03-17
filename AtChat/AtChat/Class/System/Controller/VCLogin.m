//
//  VCLogin.m
//  AtChat
//
//  Created by zhouMR on 16/11/1.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCLogin.h"
#import "VCMain.h"
#import "VCRegister.h"
#import "VCForgotPwd.h"

@interface VCLogin ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *vPhone;
@property (nonatomic, strong) UIView *vPassword;
@property (nonatomic, strong) UITextField *tfPhone;
@property (nonatomic, strong) UITextField *tfPassword;
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UIButton *btnRegister;
@property (nonatomic, strong) UIButton *btnForgot;
@end

@implementation VCLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self initUI];
}

- (void)initUI{
    [self.view addSubview:self.vPhone];
    [self.view addSubview:self.vPassword];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.btnRegister];
    [self.view addSubview:self.btnForgot];
    
    //读取沙盒
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    NSString *userPassword = [user objectForKey:@"userPassword"];
    if (userName != nil) {
        self.tfPhone.text = userName;
    }
    if (userPassword != nil) {
        self.tfPassword.text = userPassword;
    }
}


#pragma mark - Event
- (void)loginAction{
    [self hideKeyboard];
    NSString *phone = self.tfPhone.text;
    NSString *password = self.tfPassword.text;

    NSString *message = nil;
    if (phone.length < 3) {
        message = @"用户名不能少于6位";
    } else if (password.length < 6) {
        message = @"密码不能少于6位";
    }
    
    if (message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
    } else {
        //登录
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"登录中...";
        [[XmppTools sharedManager] loginWithUser:phone withPwd:password withSuccess:^{
            //存储沙盒
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:phone forKey:@"userName"];
            [userDefaults setObject:password forKey:@"userPassword"];
            [userDefaults setObject:@(FALSE) forKey:@"loginFlag"];
            [userDefaults synchronize];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            VCMain *vc = [[VCMain alloc]init];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = vc;
        } withFail:^(NSString *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

- (void)registerAction{
    VCRegister *vc = [[VCRegister alloc]init];
    [self.navigationController pushViewController:vc animated:TRUE];
}


- (void)forgotAction{
    VCForgotPwd *vc = [[VCForgotPwd alloc]init];
    [self.navigationController pushViewController:vc animated:TRUE];
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
        [_vPassword addSubview:self.tfPassword];
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


- (UITextField *)tfPassword{
    if (!_tfPassword) {
        _tfPassword = [[UITextField alloc]initWithFrame:CGRectMake(10, 2.5, DEVICEWIDTH-40, 40)];
        _tfPassword.placeholder = @"请输入密码";
        _tfPassword.secureTextEntry = YES;
        _tfPassword.delegate = self;
    }
    return _tfPassword;
}

- (UIButton*)btnLogin{
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(10, self.vPassword.bottom+10, DEVICEWIDTH-20, 45)];
        _btnLogin.backgroundColor = BASE_COLOR;
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnLogin.layer.cornerRadius = 5;
        _btnLogin.layer.masksToBounds = YES;
        [_btnLogin addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}

- (UIButton*)btnRegister{
    if (!_btnRegister) {
        _btnRegister = [[UIButton alloc]initWithFrame:CGRectMake(10, self.btnLogin.bottom+10, 100, 15)];
        [_btnRegister setTitle:@"新帐户注册" forState:UIControlStateNormal];
        [_btnRegister setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnRegister.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnRegister.titleLabel sizeToFit];
        _btnRegister.width = _btnRegister.titleLabel.width;
        [_btnRegister addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRegister;
}

- (UIButton*)btnForgot{
    if (!_btnForgot) {
        _btnForgot = [[UIButton alloc]initWithFrame:CGRectMake(10, self.btnLogin.bottom+10, DEVICEWIDTH-20, 15)];
        [_btnForgot setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_btnForgot setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btnForgot.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnForgot.titleLabel sizeToFit];
        _btnForgot.width = _btnForgot.titleLabel.width;
        _btnForgot.left = DEVICEWIDTH-10-_btnForgot.width;
        [_btnForgot addTarget:self action:@selector(forgotAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnForgot;
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
    [self.tfPassword resignFirstResponder];
}
@end
