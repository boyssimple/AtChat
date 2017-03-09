//
//  CollCellTimeLinePic.m
//  AtChat
//
//  Created by zhouMR on 2017/3/8.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "CollCellTimeLinePic.h"
@interface CollCellTimeLinePic()
@property (nonatomic, strong) UIImageView *ivImg;
@end

@implementation CollCellTimeLinePic

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        _ivImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self.contentView addSubview:_ivImg];
    }
    return self;
}

- (void)loadData:(Photo*)data{
    self.ivImg.image = data.img;
}

+ (CGFloat)calHeight{
    return (DEVICEWIDTH-50)/4.0;
}
@end
