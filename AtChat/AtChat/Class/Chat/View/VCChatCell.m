//
//  VCChatCell.m
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCChatCell.h"
#import "MLEmojiLabel.h"
# import "MJPhoto.h"
# import "MJPhotoBrowser.h"

#define kMaxContainerWidth 220.f
#define MaxChatImageViewWidh 200.f
#define MaxChatImageViewHeight 300.f

@interface VCChatCell()<MLEmojiLabelDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView *userImg;
@property(nonatomic,strong)UIView *container;
@property(nonatomic,strong)UIImageView *containerImageView;
@property(nonatomic,strong)UIImageView *maskViewImage;
@property (nonatomic, strong) MLEmojiLabel *lbContent;   //文字消息
@property(nonatomic,strong)UIImageView *ivImg;      //图片消息
@property (nonatomic, strong) XMPPMessageArchiving_Message_CoreDataObject *msg;
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
    [self.contentView addSubview:_userImg];
    
    _container = [[UIView alloc]init];
    [self.contentView addSubview:_container];
    //消息背景
    _containerImageView = [[UIImageView alloc]init];
    [_container addSubview:_containerImageView];
    
    _maskViewImage = [[UIImageView alloc]init];
    
    _lbContent = [MLEmojiLabel new];
    _lbContent.font = FONT(14*RATIO_WIDHT320);
    _lbContent.numberOfLines = 0;
    _lbContent.isNeedAtAndPoundSign = YES;
    _lbContent.disableEmoji = NO;
    _lbContent.delegate = self;
    _lbContent.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //下面是自定义表情正则和图像plist的例子
    _lbContent.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _lbContent.customEmojiPlistName = @"expressionImage_custom";
    _lbContent.textColor = [UIColor blackColor];
    _lbContent.hidden = YES;
    [_container addSubview:_lbContent];
    
    _ivImg = [[UIImageView alloc]init];
    _ivImg.hidden = YES;
    _ivImg.userInteractionEnabled = YES;
    [_container addSubview:_ivImg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        if ([self.delegate respondsToSelector:@selector(chat:didSelectWithType:withUrl:withImage:withIndex:)]) {
//            [self.delegate chat:self didSelectWithType:2 withUrl:nil withImage:self.ivImg.image withIndex:self.index];
//        }
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = nil;
        photo.srcImageView = self.ivImg;
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0;
        browser.photos = @[photo];
        [browser show];
    }];
    [_ivImg addGestureRecognizer:tap];
    
}


-(void)loadData:(XMPPMessageArchiving_Message_CoreDataObject *)msg{
    self.msg = msg;
    NSString *user = msg.bareJid.user;
    if (self.msg.isOutgoing) {
        user = [XmppTools sharedManager].userName;
    }
    NSData *photoData = [[XmppTools sharedManager] getImageData:user];
    
    UIImage *headImg;
    if (photoData) {
        headImg = [UIImage imageWithData:photoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userImg.image = headImg;
        });
    }
    
    NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
    self.ivImg.hidden = YES;
    self.lbContent.hidden = YES;
    
    if ([chatType integerValue] == IMAGE) {     //图片
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *imgBody = [msg.message attributeStringValueForName:@"imgBody"];
            NSData *data = [[NSData alloc]initWithBase64EncodedString:imgBody options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *calImage = [[UIImage alloc]initWithData:data];
            [self.ivImg setImage:calImage];
        });
        self.ivImg.hidden = NO;
    }else if([chatType integerValue] == TEXT){  //文字
        self.lbContent.text = msg.body;
        self.lbContent.hidden = NO;
    }else if([chatType integerValue] == RECORD){  //语音
        self.lbContent.hidden = NO;
        NSString *time = [msg.message attributeStringValueForName:@"time"];
        self.lbContent.text = [NSString stringWithFormat:@"[语音] %@''",time];
    }
    
    if(self.msg.isOutgoing){
        self.containerImageView.image = [self stretchImage:@"SenderTextNodeBkg"];
    }else{
        self.containerImageView.image = [self stretchImage:@"ReceiverTextNodeBkg"];
    }
    self.maskViewImage.image = self.containerImageView.image;
}

#pragma  mark - MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type{
    if ([self.delegate respondsToSelector:@selector(chat:didSelectWithType:withUrl: withIndex:)]) {
        if (type == MLEmojiLabelLinkTypeURL) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
            [self.delegate chat:self didSelectWithType:0 withUrl:[NSURL URLWithString:link] withIndex:self.index];
        }else if(type == MLEmojiLabelLinkTypePhoneNumber){
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",link];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [self.delegate chat:self didSelectWithType:1 withUrl:[NSURL URLWithString:str] withIndex:self.index];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![self.lbContent containslinkAtPoint:[touch locationInView:self.lbContent]];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.userImg.frame;
    r.origin.x = 10;
    r.origin.y = 15;
    r.size.width = 30*RATIO_WIDHT320;
    r.size.height = r.size.width;
    self.userImg.frame = r;
    
    CGFloat w ,h;
    
    NSString *chatType = [self.msg.message attributeStringValueForName:@"bodyType"];
    if ([chatType integerValue] == IMAGE) {     //图片
        NSString *imgBody = [self.msg.message attributeStringValueForName:@"imgBody"];
        CGSize size = [VCChatCell calSize:imgBody];
        r = self.ivImg.frame;
        r.origin.x = 0;
        r.origin.y = 0;
        r.size.width = size.width;
        r.size.height = size.height;
        self.ivImg.frame = r;
        
        w = size.width;
        h = size.height;
        //        [self.container setMaskView:self.maskViewImage];
        self.container.layer.mask = self.maskViewImage.layer;
    }else if([chatType integerValue] == TEXT || [chatType integerValue] == RECORD){  //文字-语音
        [self.container.layer.mask removeFromSuperlayer];
        w = [self.lbContent sizeThatFits:CGSizeMake(MAXFLOAT, 14*RATIO_WIDHT320)].width;
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
    
    r = self.containerImageView.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = w;
    r.size.height = h;
    self.containerImageView.frame = r;
    self.maskViewImage.frame = r;
    
    r = self.container.frame;
    r.origin.x = self.userImg.right+15;
    r.origin.y = 15;
    r.size.width = w;
    r.size.height = h;
    self.container.frame = r;
    
    //消息在左右判断
    
    if (self.msg.isOutgoing) {
        r = self.userImg.frame;
        r.origin.x = self.width - 10-self.userImg.width;
        self.userImg.frame = r;
        
        r = self.container.frame;
        r.origin.x = self.userImg.left - r.size.width - 15;
        self.container.frame = r;
    }
}

+ (CGFloat)calHeight:(XMPPMessageArchiving_Message_CoreDataObject *)msg{
    NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
    CGFloat height = 15;
    
    if ([chatType integerValue] == IMAGE) {     //图片
        NSString *imgBody = [msg.message attributeStringValueForName:@"imgBody"];
        CGSize size = [VCChatCell calSize:imgBody];
        height += size.height;
    }else if([chatType integerValue] == TEXT){  //文字
        MLEmojiLabel *text = [MLEmojiLabel new];
        text.font = FONT(14*RATIO_WIDHT320);
        text.numberOfLines = 0;
        text.isNeedAtAndPoundSign = YES;
        text.disableEmoji = NO;
        text.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //下面是自定义表情正则和图像plist的例子
        text.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        text.customEmojiPlistName = @"expressionImage_custom";
        [text setText: msg.body];
        
        CGFloat w = [text sizeThatFits:CGSizeMake(MAXFLOAT, 14*RATIO_WIDHT320)].width;
        if (w > kMaxContainerWidth) {
            w = kMaxContainerWidth;
        }else{
            w += 30;
        }
        CGFloat h = [text sizeThatFits:CGSizeMake(w-30, MAXFLOAT*RATIO_WIDHT320)].height;
        height += h + 30;
    }else if([chatType integerValue] == RECORD){     //语音
        NSString *time = [msg.message attributeStringValueForName:@"time"];
        
        UILabel *lbContent = [[UILabel alloc]init];
        lbContent.font = [UIFont systemFontOfSize:14*RATIO_WIDHT320];
        lbContent.numberOfLines = 0;
        lbContent.text = [NSString stringWithFormat:@"[语音] %@''",time];
        
        
        CGFloat w = [lbContent sizeThatFits:CGSizeMake(MAXFLOAT, 14*RATIO_WIDHT320)].width;
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
