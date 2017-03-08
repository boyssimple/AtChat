//
//  CellMeAction.m
//  LifeChat
//
//  Created by zhouMR on 16/5/10.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "CellMeAction.h"

@implementation CellMeAction

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        self.ivIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.ivIcon];
        
        self.lbName = [[UILabel alloc]initWithFrame:CGRectZero];
        self.lbName.font = [UIFont systemFontOfSize:14*RATIO_WIDHT320];
        self.lbName.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.lbName];
        
        self.ivArrowRight = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.ivArrowRight setImage:[UIImage imageNamed:@"ArrowRight"]];
        [self.contentView addSubview:self.ivArrowRight];
    }
    return self;
}

- (void)updateData:(NSString *)title andIcon:(NSString*)icon{
    [self.ivIcon setImage:[UIImage imageNamed:icon]];
    self.lbName.text = title;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.ivIcon.frame;
    r.size.width = 20*RATIO_WIDHT320;
    r.size.height = r.size.width;
    r.origin.x = 10;
    r.origin.y = (self.height - r.size.height)/2.0;
    self.ivIcon.frame = r;
    
    r = self.lbName.frame;
    r.size.width = DEVICEWIDTH - self.ivIcon.right - 20;
    r.size.height = 14*RATIO_WIDHT320;
    r.origin.x = self.ivIcon.right + 10;
    r.origin.y = (self.height-r.size.height)/2.0;
    self.lbName.frame = r;
    
    r = self.ivArrowRight.frame;
    r.size.width = 10*RATIO_WIDHT320;
    r.size.height = r.size.width;
    r.origin.x = DEVICEWIDTH - 20;
    r.origin.y = (self.height-r.size.height)/2.0;
    self.ivArrowRight.frame = r;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
