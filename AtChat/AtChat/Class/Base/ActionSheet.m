//
//  ActionSheet.m
//  AtChat
//
//  Created by zhouMR on 2017/3/10.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "ActionSheet.h"
#define BUTTON_HEIGHT 44.f
@implementation ActionSheet

- (id)init
{
    self = [super initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
    if (self) {
        [self installView];
    }
    
    return self;
}

- (id)initWithActions:(NSArray*)actions
{
    self = [super initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
    if (self) {
        self.array = actions;
        [self installView];
    }
    
    return self;
}

-(void)installView{
    self.windowLevel = UIWindowLevelAlert;
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    actionWindow = self;
    self.alpha = 0;
    [self addSubview:view];
    
    blackBg = [[UIView alloc] initWithFrame:self.frame];
    [blackBg setBackgroundColor:[UIColor blackColor]];
    blackBg.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [blackBg addGestureRecognizer:tap];
    [view addSubview:blackBg];
    
    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width, 146)];
    [mainBg setBackgroundColor:RGBA(247, 246, 245, 1)];
    [mainBg setBackgroundColor:[UIColor whiteColor]];
    
    int n = (int)[self.array count];
    CGFloat h = 0.5;
    for(int i=0;i<n;i++){
        NSDictionary *dic = [self.array objectAtIndex:i];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i*BUTTON_HEIGHT+i*1,mainBg.frame.size.width , BUTTON_HEIGHT)];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [mainBg addSubview:button];
        //分隔线
        if (i == n-1) {
            h = 4;
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.origin.y+button.frame.size.height, mainBg.frame.size.width, h)];
        [line setBackgroundColor:RGBA(231, 232, 231, 1)];
        [mainBg addSubview:line];
    }
    CGFloat height = n*BUTTON_HEIGHT+BUTTON_HEIGHT+(n-1)*h+4;
    mainBg.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, height);
    //取消
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, mainBg.frame.size.height-BUTTON_HEIGHT,mainBg.frame.size.width , BUTTON_HEIGHT)];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:RGBA(137, 137, 137, 1) forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [mainBg addSubview:cancelBtn];
    [view addSubview:mainBg];
}



- (void)show {
    [self makeKeyAndVisible];
    [UIView animateWithDuration:0.3 animations:^{
        blackBg.alpha = 0.5;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = mainBg.frame;
        f.origin.y = [UIScreen mainScreen].bounds.size.height - mainBg.frame.size.height;
        mainBg.frame = f;
        actionWindow.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        blackBg.alpha = 0;
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        //actionWindow = 0;
        CGRect f = mainBg.frame;
        f.origin.y = [UIScreen mainScreen].bounds.size.height;
        mainBg.frame = f;
    } completion:^(BOOL finished) {
        NSArray *arr = [self subviews];
        for (UIView *v in arr) {
            [v removeFromSuperview];
        }
        actionWindow.hidden = true;
        actionWindow = nil;
        [self resignKeyWindow];
    }];
}

-(void)clickAction:(UIButton*)sender{
    [self dismiss];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(actionSheetClickedButtonAtIndex:)]){
        NSInteger index = sender.tag - 100;
        [self.delegate actionSheetClickedButtonAtIndex:index];
    }
}

@end
