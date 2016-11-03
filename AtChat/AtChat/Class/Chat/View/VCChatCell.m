//
//  VCChatCell.m
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCChatCell.h"

#define kMaxContainerWidth 220.f
#define MaxChatImageViewWidh 200.f
#define MaxChatImageViewHeight 300.f

@interface VCChatCell()
@property(nonatomic,strong)UIImageView *userImg;
@property(nonatomic,strong)UIImageView *bgImg;
@property(nonatomic,strong)UIView *container;
@property (nonatomic, strong) UILabel *lbContent;   //文字消息
@property(nonatomic,strong)UIImageView *ivImg;      //图片消息
@property (nonatomic, strong) Message *msg;
@end
@implementation VCChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor clearColor]];
    _userImg = [[UIImageView alloc]init];
    _userImg.image= [UIImage imageNamed:@"abc"];
    [self.contentView addSubview:_userImg];
    
    _container = [[UIView alloc]init];
    [self.contentView addSubview:_container];
    //消息背景
    _bgImg= [[UIImageView alloc]init];
    [_container addSubview:_bgImg];
    
    _lbContent = [[UILabel alloc]init];
    _lbContent.font = [UIFont systemFontOfSize:14];
    _lbContent.numberOfLines = 0;
    _lbContent.textColor = [UIColor blackColor];
    _lbContent.hidden = YES;
    [_container addSubview:_lbContent];
    
    _ivImg = [[UIImageView alloc]init];
    _ivImg.hidden = YES;
    [_container addSubview:_ivImg];
    
}


-(void)loadData:(Message *)msg{
    self.msg = msg;
    self.ivImg.hidden = YES;
    self.lbContent.hidden = YES;
    if (msg.msgType == IMAGE) {     //图片
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [[NSData alloc]initWithBase64EncodedString:msg.content options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *calImage = [[UIImage alloc]initWithData:data];
            [self.ivImg setImage:calImage];
        });
        self.ivImg.hidden = NO;
    }else if(msg.msgType == TEXT){  //文字
        self.lbContent.text = msg.content;
        self.lbContent.hidden = NO;
    }else if(msg.msgType == RECORD){  //语音
        self.lbContent.hidden = NO;
        self.lbContent.text = [NSString stringWithFormat:@"[语音] %@''",msg.voiceTime];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.userImg.frame;
    r.origin.x = 10;
    r.origin.y = 15;
    r.size.width = 30;
    r.size.height = 30;
    self.userImg.frame = r;
    
    CGFloat w ,h;
    
    if (self.msg.msgType == IMAGE) {     //图片
        CGSize size = [VCChatCell calSize:self.msg.content];
        r = self.ivImg.frame;
        r.origin.x = 0;
        r.origin.y = 0;
        r.size.width = size.width;
        r.size.height = size.height;
        self.ivImg.frame = r;
        
        w = size.width;
        h = size.height;
        [self.container setMaskView:self.bgImg];
    }else if(self.msg.msgType == TEXT || self.msg.msgType == RECORD){  //文字-语音
        w = [self.lbContent sizeThatFits:CGSizeMake(MAXFLOAT, 14)].width;
        if (w > kMaxContainerWidth) {
            w = kMaxContainerWidth;
        }else{
            w += 30;
        }
        h = [self.lbContent sizeThatFits:CGSizeMake(w-30, MAXFLOAT)].height;
        
        r = self.lbContent.frame;
        r.origin.x = 15;
        r.origin.y = 10;
        r.size.width = w-30;
        r.size.height = h;
        self.lbContent.frame = r;
        h += 30;
    }
   
    r = self.bgImg.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = w;
    r.size.height = h;
    self.bgImg.frame = r;
    self.bgImg.image = [self stretchImage:@"ReceiverTextNodeBkg"];
    
    r = self.container.frame;
    r.origin.x = self.userImg.right+15;
    r.origin.y = 15;
    r.size.width = w;
    r.size.height = h;
    self.container.frame = r;
    
    //消息在左右判断
    if (self.msg.type == ME) {
        r = self.userImg.frame;
        r.origin.x = self.width - 40;
        self.userImg.frame = r;
        
        r = self.container.frame;
        r.origin.x = self.userImg.left - r.size.width - 15;
        self.container.frame = r;
        self.bgImg.image = [self stretchImage:@"SenderTextNodeBkg"];
    }
}

+ (CGFloat)calHeight:(Message *)msg{
    CGFloat height = 15;
    
    
    if (msg.msgType == IMAGE) {     //图片
        CGSize size = [VCChatCell calSize:msg.content];
        height += size.height;
    }else if(msg.msgType == TEXT){  //文字
        UILabel *lbContent = [[UILabel alloc]init];
        lbContent.font = [UIFont systemFontOfSize:14];
        lbContent.numberOfLines = 0;
        lbContent.text = msg.content;
        
        
        CGFloat w = [lbContent sizeThatFits:CGSizeMake(MAXFLOAT, 14)].width;
        if (w > kMaxContainerWidth) {
            w = kMaxContainerWidth;
        }else{
            w += 30;
        }
        CGFloat h = [lbContent sizeThatFits:CGSizeMake(w-30, MAXFLOAT)].height;
        height += h + 30;
    }else if(msg.msgType == RECORD){     //语音
        UILabel *lbContent = [[UILabel alloc]init];
        lbContent.font = [UIFont systemFontOfSize:14];
        lbContent.numberOfLines = 0;
        lbContent.text = [NSString stringWithFormat:@"[语音] %@''",msg.voiceTime];
        
        
        CGFloat w = [lbContent sizeThatFits:CGSizeMake(MAXFLOAT, 14)].width;
        if (w > kMaxContainerWidth) {
            w = kMaxContainerWidth;
        }else{
            w += 30;
        }
        CGFloat h = [lbContent sizeThatFits:CGSizeMake(w-30, MAXFLOAT)].height;
        height += h + 30;
    }
    
    return height;
}

- (UIImage*)stretchImage:(NSString*)name
{
    UIImage *image = nil;
    if (name && name.length > 0) {
        image = [UIImage imageNamed:name];
        CGSize imgSize = image.size;
        CGPoint pt = CGPointMake(.5, .5);
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(imgSize.height * pt.y,
                                                                    imgSize.width * pt.x,
                                                                    imgSize.height * (1 - pt.y),
                                                                    imgSize.width * (1 - pt.x))];
        
        return image;
    }
    return nil;
}

// 根据图片的宽高尺寸设置图片约束
+(CGSize)calSize:(NSString *)str{
    CGFloat standardWidthHeightRatio = MaxChatImageViewWidh / MaxChatImageViewHeight;
    CGFloat widthHeightRatio = 0;
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *calImage = [[UIImage alloc]initWithData:data];
    CGFloat h = calImage.size.height;
    CGFloat w = calImage.size.width;
    
    if (w > MaxChatImageViewWidh || w > MaxChatImageViewHeight) {
        
        widthHeightRatio = w / h;
        if (widthHeightRatio > standardWidthHeightRatio) {
            w = MaxChatImageViewWidh;
            h = w * (calImage.size.height / calImage.size.width);
        } else {
            h = MaxChatImageViewHeight;
            w = h * widthHeightRatio;
        }
    }
    return CGSizeMake(w, h);
}

@end
