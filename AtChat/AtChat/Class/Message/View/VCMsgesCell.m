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
        
        _vLine = [[UIView alloc]init];
        _vLine.backgroundColor = RGB3(229);
        [self.contentView addSubview:_vLine];
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

- (void)updateData:(XMPPMessageArchiving_Contact_CoreDataObject*)data{
    NSData *photoData = [[XmppTools sharedManager] getImageData:data.bareJid];
    
    UIImage *headImg;
    if (photoData) {
        headImg = [UIImage imageWithData:photoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ivImg.image = headImg;
        });
    }
    
    self.lbName.text = data.bareJid.user;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:data.mostRecentMessageTimestamp];
    self.lbTime.text = strDate;
    
    self.lbMsg.text  = data.mostRecentMessageBody;
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
    
    r = self.vLine.frame;
    r.origin.x = 15;
    r.origin.y = self.height-0.5;
    r.size.width = DEVICEWIDTH-15;
    r.size.height = 0.5;
    self.vLine.frame = r;
}
@end
