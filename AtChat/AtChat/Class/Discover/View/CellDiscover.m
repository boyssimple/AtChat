//
//  CellMeAction.m
//  LifeChat
//
//  Created by zhouMR on 16/5/10.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "CellDiscover.h"

@implementation CellDiscover

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        self.ivIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        [self.contentView addSubview:self.ivIcon];
        
        self.lbName = [[UILabel alloc]initWithFrame:CGRectMake(self.ivIcon.right + 10, self.ivIcon.top+3, DEVICEWIDTH-self.ivIcon.right-10-10, 15)];
        self.lbName.font = [UIFont systemFontOfSize:12];
        self.lbName.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.lbName];
        
        self.ivArrowRight = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICEWIDTH-20, 10, 10, 10)];
        [self.ivArrowRight setImage:[UIImage imageNamed:@"ArrowRight"]];
        [self.contentView addSubview:self.ivArrowRight];
    }
    return self;
}

- (void)updateData:(NSString *)title andIcon:(NSString*)icon{
    [self.ivIcon setImage:[UIImage imageNamed:icon]];
    self.lbName.text = title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.ivIcon.center = CGPointMake(self.ivIcon.center.x, self.contentView.center.y);
    self.lbName.center = CGPointMake(self.lbName.center.x, self.contentView.center.y);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
