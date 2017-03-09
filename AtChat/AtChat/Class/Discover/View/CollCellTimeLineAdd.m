//
//  CollCellTimeLineAdd.m
//  AtChat
//
//  Created by zhouMR on 2017/3/8.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "CollCellTimeLineAdd.h"
@interface CollCellTimeLineAdd()
@property (nonatomic, strong) UIView *horLine;
@property (nonatomic, strong) UIView *verLine;
@end
@implementation CollCellTimeLineAdd

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.layer.borderColor = RGB3(229).CGColor;
        self.contentView.layer.borderWidth = 1;
        
        _horLine = [[UIView alloc]initWithFrame:CGRectZero];
        _horLine.backgroundColor = RGB3(229);
        [self.contentView addSubview:_horLine];
        
        _verLine = [[UIView alloc]initWithFrame:CGRectZero];
        _verLine.backgroundColor = RGB3(229);
        [self.contentView addSubview:_verLine];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.horLine.frame;
    r.size.width = self.width - 20;
    r.size.height = 1;
    r.origin.x = (self.width-r.size.width)/2.0;
    r.origin.y = (self.height-r.size.height)/2.0;
    self.horLine.frame = r;
    
    r = self.verLine.frame;
    r.size.width = 1;
    r.size.height = self.width - 20;
    r.origin.x = (self.width-r.size.width)/2.0;
    r.origin.y = (self.height-r.size.height)/2.0;
    self.verLine.frame = r;
}

@end
