//
//  CellTimeLine.m
//  TimeLine
//
//  Created by zhouMR on 16/5/12.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "CellTimeLine.h"
#import "TimeLineMenu.h"

#define MaxChatImageViewWidh 200.f
#define MaxChatImageViewHeight 300.f
NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@interface CellTimeLine()
@property (nonatomic, strong) UIImageView *ivImg;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbContent;
@property (nonatomic, strong) UIView *vImages;
@property (nonatomic, strong) UILabel *lbTime;
@property (nonatomic, strong) UIView *vLine;
@property (nonatomic, strong) UIButton *btnMsg;
@property (nonatomic, strong) TimeLineMenu *menu;
@end

@implementation CellTimeLine

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.ivImg = [[UIImageView alloc]init];
        [self addSubview:self.ivImg];
        
        self.lbName = [[UILabel alloc]init];
        self.lbName.font = [UIFont systemFontOfSize:14];
        self.lbName.textColor = RGB(104,101,139);
        [self addSubview:self.lbName];
        
        self.lbContent = [[UILabel alloc]init];
        self.lbContent.font = [UIFont systemFontOfSize:14];
        self.lbContent.textColor = [UIColor blackColor];
        self.lbContent.numberOfLines = 0;
        [self addSubview:self.lbContent];
        
        self.vImages = [[UIView alloc]init];
        [self addSubview:self.vImages];
        
        self.lbTime = [[UILabel alloc]init];
        self.lbTime.font = [UIFont systemFontOfSize:10];
        self.lbTime.textColor = [UIColor grayColor];
        [self addSubview:self.lbTime];
        
        self.btnMsg = [[UIButton alloc]init];
        [self.btnMsg setImage:[UIImage imageNamed:@"TimeLineMsg"] forState:UIControlStateNormal];
        [self.btnMsg addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnMsg];
        
        self.vLine = [[UIView alloc]init];
        [self.vLine setBackgroundColor:RGB(230,230,250)];
        [self addSubview:self.vLine];
        
        self.menu = [[TimeLineMenu alloc]init];
        [self addSubview:self.menu];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.ivImg.frame = CGRectMake(10, 15, 30, 30);
    
    CGSize ns = [self.lbName sizeThatFits:CGSizeMake(MAXFLOAT, 14)];
    self.lbName.frame = CGRectMake(self.ivImg.right+10, self.ivImg.top+2, ns.width, 14);
    
    CGSize cs = [self.lbContent sizeThatFits:CGSizeMake(DEVICEWIDTH-self.lbName.left-10, MAXFLOAT)];
    self.lbContent.frame = CGRectMake(self.lbName.left, self.lbName.bottom+10, DEVICEWIDTH-self.lbName.left-10, cs.height);
    
    NSArray *subs = self.vImages.subviews;
    if (subs.count > 0) {
        self.vImages.width = self.lbContent.width;
        self.vImages.top = self.lbContent.bottom + 10;
        self.vImages.left = self.lbContent.left;
        UIView *v = ((UIView *)subs.lastObject);
        self.vImages.height = v.top + v.height;
    }else{
        self.vImages.height = 0;
    }
    
    CGSize ts = [self.lbTime sizeThatFits:CGSizeMake(MAXFLOAT, 10)];
    self.lbTime.frame = CGRectMake(self.lbName.left, self.vImages.bottom+10, ts.width, 10);
    
    self.btnMsg.frame = CGRectMake(DEVICEWIDTH-30, self.lbTime.bottom-3, 20, 20);
    
    self.menu.height = 36;
    self.menu.top = self.btnMsg.top-10;
    self.menu.left = self.btnMsg.left-self.menu.width;
    
    self.vLine.frame = CGRectMake(0, self.lbTime.bottom+15, DEVICEWIDTH, 0.5);
}

- (void)updateData:(TimeLine*)data{
    [self.ivImg setImage:[UIImage imageNamed:@"img.jpg"]];
    self.lbName.text = data.name;
    self.lbContent.text = data.content;
    self.lbTime.text = data.time;
    
    //图集
    NSInteger count = data.images.count;
    CGFloat width = 0 , height = 0 ,margin = 4;
    if (count > 1) {
        width = (DEVICEWIDTH-100-margin*2)/3.0;
        height = width;
    }else if(count == 1){
        NSString *url = [data.images lastObject];
        CGSize s = [CellTimeLine calSize:url];
        width = s.width;
        height = s.height;
        
    }
    int n = 0;
    CGFloat x = 0,y = 0;
    for (NSString *url in data.images) {
        if (n % 3 == 0) {
            x = 0;
        }
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
        [img downloadImage:url];
        [self.vImages addSubview:img];
        img.userInteractionEnabled = TRUE;
        UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg:)];
        [img addGestureRecognizer:imgTap];
        n++;
        x += width + margin;
        if (n % 3 == 0) {
            y += height +margin;
        }
    }
}

+ (CGFloat)calHeight:(TimeLine*)data{
    CGFloat height = 86.5;
    UILabel *lbContent = [[UILabel alloc]init];
    lbContent.font = [UIFont systemFontOfSize:14];
    lbContent.numberOfLines = 0;
    lbContent.text = data.content;
    
    CGSize cs = [lbContent sizeThatFits:CGSizeMake(DEVICEWIDTH-60, MAXFLOAT)];
    height += cs.height;
    
    //图集
    NSInteger count = data.images.count;
    CGFloat h = 0 , margin = 4;
    if (count > 1) {
        CGFloat w = (DEVICEWIDTH-100-margin*2)/3.0;
        if (count % 3 == 0) {
            h = (count/3)*w+((count/3)-1)*margin;
        }else{
            h = (count/3+1)*w+(count/3)*margin;
        }
    }else if(count == 1){
        NSString *url = [data.images lastObject];
        CGSize s = [CellTimeLine calSize:url];
        height += s.height;
    }
    height += h;
    return height;
}


// 根据图片的宽高尺寸设置图片约束
+(CGSize)calSize:(NSString *)str{
    CGFloat standardWidthHeightRatio = MaxChatImageViewWidh / MaxChatImageViewHeight;
    CGFloat widthHeightRatio = 0;
    NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc]initWithString:str]];
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

- (void)toggleMenu{
    if (isShowing) {
        [self closeMenu];
    }else{
        [self postOperationButtonClickedNotification];
        [self showMenu];
    
    }
    [super layoutSubviews];
}

- (void)closeMenu{
    isShowing = FALSE;
    [UIView animateWithDuration:0.2 animations:^{
        self.menu.width = 0;
        self.menu.left = self.btnMsg.left - self.menu.width;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showMenu{
    isShowing = TRUE;
    [UIView animateWithDuration:0.2 animations:^{
        self.menu.width = 161;
        self.menu.left = self.btnMsg.left - self.menu.width;
    } completion:^(BOOL finished) {
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (isShowing) {
        [self closeMenu];
    }
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    if (isShowing) {
        [self closeMenu];
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:nil];
}

- (void)clickImg:(UIGestureRecognizer*)ges{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectImg:)]) {
        [self.delegate selectImg:(UIImageView*)ges.view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
