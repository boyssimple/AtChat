//
//  FaceCollCell.m
//  AtChat
//
//  Created by zhouMR on 2017/3/15.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "FaceCollCell.h"
@interface FaceCollCell()
@property (nonatomic, strong) UIImageView *ivImg;
@end
@implementation FaceCollCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _ivImg = [[UIImageView alloc]init];
        [self.contentView addSubview:_ivImg];
    }
    return self;
}

- (void)loadData:(NSIndexPath*)indexPath{
    NSString *url = [NSString stringWithFormat:@"Expression_%zi",indexPath.row+1];
    self.ivImg.image = [UIImage imageNamed:[@"MLEmoji_Expression.bundle" stringByAppendingPathComponent:url]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.ivImg.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = self.width;
    r.size.height = self.height;
    self.ivImg.frame = r;
}

@end
