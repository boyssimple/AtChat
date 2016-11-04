//
//  TimeLineMenu.m
//  TimeLine
//
//  Created by zhouMR on 16/5/12.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "TimeLineMenu.h"

@implementation TimeLineMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.autoresizesSubviews = TRUE;
        self.layer.cornerRadius = 5;
        self.backgroundColor = RGB(69, 74, 76);
        self.btnLike = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 36)];
        self.btnLike.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.btnLike setTitle:@"赞" forState:UIControlStateNormal];
        [self.btnLike setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.btnLike];
        CGFloat margin = 5;
        
        self.centerLine = [[UIView alloc]initWithFrame:CGRectMake(81, margin, 1, 36-margin*2)];
        self.centerLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.centerLine.backgroundColor = [UIColor grayColor];
        [self addSubview:self.centerLine];
        
        self.btnComment = [[UIButton alloc]initWithFrame:CGRectMake(81, 0, 80, 36)];
        self.btnComment.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.btnComment setTitle:@"评论" forState:UIControlStateNormal];
        [self addSubview:self.btnComment];
    }
    return self;
}

- (void)layoutSubviews{
    CGFloat margin = 5;
    self.btnLike.frame = CGRectMake(0, 0, (self.width-1)/2.0, self.height);
    self.centerLine.frame = CGRectMake(self.btnLike.right, margin, 1, 36-margin*2);
    self.btnComment.frame = CGRectMake(self.centerLine.right, 0, self.btnLike.width, self.height);
}

@end
