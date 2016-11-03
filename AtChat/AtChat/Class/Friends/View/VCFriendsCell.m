//
//  VCMsgesCell.m
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCFriendsCell.h"
@interface VCFriendsCell()
@property (nonatomic, strong) UIImageView *ivImg;
@property (nonatomic, strong) UILabel *lbName;
@property(nonatomic,strong)UILabel *status;
@end
@implementation VCFriendsCell

+ (CGFloat)calHeight{
    return 60;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ivImg = [[UIImageView alloc]init];
        _ivImg.backgroundColor = randomColor;
        [self.contentView addSubview:_ivImg];
        
        _lbName = [[UILabel alloc]init];
        _lbName.font = [UIFont boldSystemFontOfSize:15];
        _lbName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_lbName];
        
        _status = [[UILabel alloc]init];
        _status.textColor = [UIColor blackColor];
        _status.font = [UIFont boldSystemFontOfSize:12];
        _status.text = @"[在线]";
        [self.contentView addSubview:_status];
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

- (void)updateData:(XMPPUserMemoryStorageObject*)user{
    self.ivImg.image = [UIImage imageNamed:@"abc"];
    self.lbName.text = user.jid.user;
    if (user.isOnline) {
        self.status.text = @"[在线]";
    }else{
        self.status.text = @"[离线]";
    }
    NSData *photoData = [[XmppTools sharedManager] getImageData:user.jid.user];
    
    UIImage *headImg;
    if (photoData) {
        headImg = [UIImage imageWithData:photoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ivImg.image = headImg;
        });
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.ivImg.frame;
    r.origin.x = 15;
    r.origin.y = 15;
    r.size.width = 30;
    r.size.height = 30;
    self.ivImg.frame = r;
    
    r = self.lbName.frame;
    r.origin.x = self.ivImg.right+15;
    r.origin.y = (self.height-15)/2.0;
    r.size.width = DEVICEWIDTH-(self.ivImg.right+35);
    r.size.height = 15;
    self.lbName.frame = r;
    
    CGSize size = [self.status sizeThatFits:CGSizeMake(MAXFLOAT, 12)];
    r = self.status.frame;
    r.origin.x = self.width - 15-size.width;
    r.origin.y = (self.height-12)/2.0;
    r.size.width = size.width;
    r.size.height = 12;
    self.status.frame = r;
}
@end
