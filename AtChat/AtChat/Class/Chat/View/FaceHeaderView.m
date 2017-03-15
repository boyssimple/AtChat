//
//  FaceHeaderView.m
//  AtChat
//
//  Created by zhouMR on 2017/3/15.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "FaceHeaderView.h"

@interface FaceHeaderView()
@property (nonatomic, strong) UILabel *label;
@end
@implementation FaceHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, DEVICEWIDTH-20, 30)];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor blackColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.label.text = text;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.label.frame;
    r.origin.x = 10;
    r.origin.y = 0;
    r.size.height = self.height;
    r.size.width = DEVICEWIDTH - 20;
    self.label.frame = r;
}
@end
