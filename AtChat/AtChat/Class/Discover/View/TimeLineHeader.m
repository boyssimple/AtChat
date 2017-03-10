//
//  TimeLineHeader.m
//  TimeLine
//
//  Created by zhouMR on 16/5/12.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "TimeLineHeader.h"

@implementation TimeLineHeader


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _ivBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, 250)];
        [_ivBg setImage:[UIImage imageNamed:@"img.jpg"]];
        _ivBg.userInteractionEnabled = YES;
        [self addSubview:_ivBg];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerAction)];
        [_ivBg addGestureRecognizer:tap];
        
        _ivImg = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICEWIDTH-60, _ivBg.bottom-35, 50, 50)];
        _ivImg.layer.borderColor = [UIColor whiteColor].CGColor;
        _ivImg.layer.borderWidth = 2;
        [self addSubview:_ivImg];
        
        _lbName = [[UILabel alloc]initWithFrame:CGRectMake(_ivImg.left - 80, _ivBg.bottom-25, 65, 15)];
        _lbName.font = [UIFont systemFontOfSize:15];
        _lbName.textColor = [UIColor whiteColor];
        [self addSubview:_lbName];
    }
    return self;
}

- (void)headerAction{
    if ([self.delegate respondsToSelector:@selector(headerAction)]) {
        [self.delegate headerAction];
    }
}

- (void)updateData{
    self.lbName.text = [NSString stringWithFormat:@"%@",[XmppTools sharedManager].userName];
    NSData *photoData = [[XmppTools sharedManager] getCurUserImageData];
    
    UIImage *headImg;
    if (photoData) {
        headImg = [UIImage imageWithData:photoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ivImg.image = headImg;
        });
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = [self.lbName sizeThatFits:CGSizeMake(MAXFLOAT, 15)];
    self.lbName.left = self.ivImg.left - size.width - 15;
    self.lbName.width = size.width;
}

@end
