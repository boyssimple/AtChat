//
//  VCMsgesCell.m
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCMsgesCell.h"
@interface VCMsgesCell()
@property (nonatomic, strong) UIImageView *ivImg;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbMsg;
@property (nonatomic, strong) UILabel *lbTime;
@end
@implementation VCMsgesCell

+ (CGFloat)calHeight{
    return 80;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ivImg = [[UIImageView alloc]init];
        _ivImg.layer.cornerRadius = 5;
        _ivImg.layer.masksToBounds = YES;
        _ivImg.backgroundColor = randomColor;
        [self.contentView addSubview:_ivImg];
        
        _lbName = [[UILabel alloc]init];
        _lbName.font = [UIFont boldSystemFontOfSize:15];
        _lbName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_lbName];
        
        _lbMsg = [[UILabel alloc]init];
        _lbMsg.font = [UIFont systemFontOfSize:14];
        _lbMsg.textColor = [UIColor grayColor];
        [self.contentView addSubview:_lbMsg];
        
        _lbTime = [[UILabel alloc]init];
        _lbTime.font = [UIFont systemFontOfSize:12];
        _lbTime.textColor = [UIColor grayColor];
        [self.contentView addSubview:_lbTime];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.ivImg.backgroundColor = [UIColor whiteColor];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.ivImg.backgroundColor = [UIColor whiteColor];
}

- (void)updateData{
    self.ivImg.image = [UIImage imageNamed:@"abc"];
    self.lbName.text = @"Sharelien";
    self.lbTime.text = @"13:14";
    self.lbMsg.text  = @"想好了，咱们就在一起哦";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.ivImg.frame;
    r.origin.x = 15;
    r.origin.y = 15;
    r.size.width = 50;
    r.size.height = 50;
    self.ivImg.frame = r;
    
    r = self.lbName.frame;
    r.origin.x = self.ivImg.right+15;
    r.origin.y = self.ivImg.top + 5;
    r.size.width = DEVICEWIDTH-(self.ivImg.right+15)*2;
    r.size.height = 15;
    self.lbName.frame = r;
    
    CGSize size = [self.lbTime sizeThatFits:CGSizeMake(MAXFLOAT, 12)];
    r = self.lbTime.frame;
    r.origin.x = DEVICEWIDTH - self.ivImg.left - size.width;
    r.origin.y = self.lbName.top;
    r.size.width = size.width;
    r.size.height = 12;
    self.lbTime.frame = r;
    
    r = self.lbMsg.frame;
    r.origin.x = self.lbName.left;
    r.origin.y = self.ivImg.bottom - 24;
    r.size.width = self.lbTime.right - self.lbName.left;
    r.size.height = 14;
    self.lbMsg.frame = r;
}
@end
