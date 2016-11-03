//
//  FaceView.m
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "FaceView.h"
@interface FaceView()
@property (nonatomic, strong) UIView *vDownBg;
@property (nonatomic, strong) UIButton *btnSend;
@property (nonatomic, strong) UIButton *btnDefault;
@property (nonatomic, strong) UIButton *btnEmoji;
@property (nonatomic, strong) UIButton *btnflower;
@property (nonatomic, strong) UIView *vHorLine;
@property (nonatomic, strong) UIView *vLineOne;
@property (nonatomic, strong) UIView *vLineTwo;
@end
@implementation FaceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = RGB3(249);
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _vDownBg = [[UIView alloc]init];
    _vDownBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:_vDownBg];
    
    _btnSend = [[UIButton alloc]init];
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
    _btnSend.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnSend setTitleColor:[UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
    [_vDownBg addSubview:_btnSend];
    
    _btnDefault = [[UIButton alloc]init];
    [_btnDefault setTitle:@"默认" forState:UIControlStateNormal];
    _btnDefault.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnDefault setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnDefault.backgroundColor = RGB3(179);
    [_vDownBg addSubview:_btnDefault];
    
    _btnEmoji = [[UIButton alloc]init];
    [_btnEmoji setTitle:@"Emoji" forState:UIControlStateNormal];
    _btnEmoji.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnEmoji setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnEmoji.backgroundColor = RGB3(179);
    [_vDownBg addSubview:_btnEmoji];
    
    _btnflower = [[UIButton alloc]init];
    [_btnflower setTitle:@"小花" forState:UIControlStateNormal];
    _btnflower.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnflower setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnflower.backgroundColor = RGB3(179);
    [_vDownBg addSubview:_btnflower];
    
    _vHorLine = [[UIView alloc]init];
    _vHorLine.backgroundColor = [UIColor blackColor];
    _vHorLine.alpha = 0.3;
    [_vDownBg addSubview:_vHorLine];
    
    _vLineOne = [[UIView alloc]init];
    _vLineOne.backgroundColor = [UIColor blackColor];
    _vLineOne.alpha = 0.3;
    [_vDownBg addSubview:_vLineOne];
    
    _vLineTwo = [[UIView alloc]init];
    _vLineTwo.backgroundColor = [UIColor blackColor];
    _vLineTwo.alpha = 0.3;
    [_vDownBg addSubview:_vLineTwo];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.vDownBg.frame;
    r.origin.x = 0;
    r.origin.y = self.height - 40;
    r.size.width = self.width;
    r.size.height = 40;
    self.vDownBg.frame = r;
    
    r = self.btnSend.frame;
    r.origin.x = self.width - 50*RATIO_WIDHT320;
    r.origin.y = 0;
    r.size.width = 50*RATIO_WIDHT320;
    r.size.height = self.vDownBg.height;
    self.btnSend.frame = r;
    
    CGFloat w = (self.width - self.btnSend.width - 2)/3.0;
    r = self.vHorLine.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = self.width - self.btnSend.width;
    r.size.height = 1;
    self.vHorLine.frame = r;
    
    r = self.btnDefault.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = w;
    r.size.height = self.vDownBg.height;
    self.btnDefault.frame = r;
    
    r = self.vLineOne.frame;
    r.origin.x = self.btnDefault.right;
    r.origin.y = 0;
    r.size.width = 1;
    r.size.height = self.vDownBg.height;
    self.vLineOne.frame = r;
    
    r = self.btnEmoji.frame;
    r.origin.x = self.vLineOne.right;
    r.origin.y = 0;
    r.size.width = w;
    r.size.height = self.vDownBg.height;
    self.btnEmoji.frame = r;
    
    r = self.vLineOne.frame;
    r.origin.x = self.btnDefault.right;
    r.origin.y = 0;
    r.size.width = 1;
    r.size.height = self.vDownBg.height;
    self.vLineOne.frame = r;
    
    r = self.btnflower.frame;
    r.origin.x = self.btnEmoji.right;
    r.origin.y = 0;
    r.size.width = w;
    r.size.height = self.vDownBg.height;
    self.btnflower.frame = r;
}

@end
