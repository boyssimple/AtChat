//
//  CellSetting.m
//  LifeChat
//
//  Created by zhouMR on 16/5/10.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "CellSetting.h"

@implementation CellSetting

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        self.lbName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 12*RATIO_WIDHT320)];
        self.lbName.font = [UIFont systemFontOfSize:12*RATIO_WIDHT320];
        self.lbName.textColor = [UIColor blackColor];
        self.lbName.text = @"已经关闭";
        [self.contentView addSubview:self.lbName];
        
        
        self.ivArrowRight = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICEWIDTH-25, 10, 10*RATIO_WIDHT320, 10*RATIO_WIDHT320)];
        [self.ivArrowRight setImage:[UIImage imageNamed:@"ArrowRight"]];
        [self.contentView addSubview:self.ivArrowRight];
        
        self.lbRightText = [[UILabel alloc]initWithFrame:CGRectMake(self.ivArrowRight.left-50, 0, 40, 10)];
        self.lbRightText.font = [UIFont systemFontOfSize:10*RATIO_WIDHT320];
        self.lbRightText.textColor = [UIColor grayColor];
        self.lbRightText.text = @"已经关闭";
        [self.contentView addSubview:self.lbRightText];
    }
    return self;
}

-(void)updateData:(NSString *)name withRightText:(NSString*)text withType:(int)type{
    if (type == 0) {
        self.lbName.text = name;
        self.lbRightText.text = text;
        self.lbRightText.hidden = FALSE;
        self.ivArrowRight.hidden = FALSE;
    }else if(type == 1){
        self.lbName.text = name;
        self.lbRightText.hidden = TRUE;
        self.ivArrowRight.hidden = FALSE;
    }else if(type == 2){
        self.lbName.text = name;
        self.lbRightText.hidden = TRUE;
        self.ivArrowRight.hidden = TRUE;
    }
    self.type = type;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize ns = [self.lbName sizeThatFits:CGSizeMake(MAXFLOAT, 12*RATIO_WIDHT320)];
    self.lbName.width = ns.width;
    if (self.type == 2) {
        self.lbName.center = self.contentView.center;
    }else{
        self.lbName.top = (self.contentView.height-self.lbName.height)/2.0;
    }
    CGSize rs = [self.lbRightText sizeThatFits:CGSizeMake(MAXFLOAT, 10*RATIO_WIDHT320)];
    self.lbRightText.width = rs.width;
    self.lbRightText.left = self.ivArrowRight.left-rs.width-10;
    self.lbRightText.top = (self.contentView.height-self.lbRightText.height)/2.0;
    
    self.ivArrowRight.top = (self.contentView.height-self.ivArrowRight.height)/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
