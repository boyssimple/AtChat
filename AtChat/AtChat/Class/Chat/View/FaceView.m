//
//  FaceView.m
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "FaceView.h"
#import "FaceHeaderView.h"
#import "FaceCollCell.h"

#define CELLIDEN @"Cell"
#define CELLHeader @"Header"

@interface FaceView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *vTopBg;
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) NSArray *emojiDictionary;


@property (nonatomic, strong) UIView *vDownBg;
@property (nonatomic, strong) UIButton *btnSend;
@property (nonatomic, strong) UIButton *btnDefault;
@property (nonatomic, strong) UIButton *btnEmoji;
@property (nonatomic, strong) UIButton *btnflower;
@property (nonatomic, strong) UIView *vHorLine;
@property (nonatomic, strong) UIView *vLineOne;
@property (nonatomic, strong) UIView *vLineTwo;
@end
@implementation FaceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = RGB3(249);
        [self initUI];
        
    }
    return self;
}

#pragma mark - 表情包字典
- (NSArray *)emojiDictionary {
    static NSArray *emojiDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"expression_custom.plist"];
        emojiDictionary = [NSArray arrayWithContentsOfFile:emojiFilePath];
    });
    return emojiDictionary;
}


- (void)initUI{
    
    _vTopBg = [[UIView alloc]init];
    [self addSubview:_vTopBg];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    CGRect r = CGRectMake(0, 0, self.width, self.height);
    _collView = [[UICollectionView alloc]initWithFrame:r collectionViewLayout:layout];
    [_collView registerClass:[FaceCollCell class] forCellWithReuseIdentifier:CELLIDEN];
    [_collView registerClass:[FaceHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CELLHeader];
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    _collView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collView];
    
    _vDownBg = [[UIView alloc]init];
    _vDownBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:_vDownBg];
    
    _btnSend = [[UIButton alloc]init];
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
    _btnSend.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnSend setTitleColor:[UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
    [_btnSend addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [_vDownBg addSubview:_btnSend];
    
    _btnDefault = [[UIButton alloc]init];
    [_btnDefault setTitle:@"默认" forState:UIControlStateNormal];
    _btnDefault.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnDefault setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnDefault.backgroundColor = RGB3(179);
    [_vDownBg addSubview:_btnDefault];
    
    _btnEmoji = [[UIButton alloc]init];
    [_btnEmoji setTitle:@"Emoji" forState:UIControlStateNormal];
    _btnEmoji.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnEmoji setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnEmoji.backgroundColor = RGB3(179);
    [_vDownBg addSubview:_btnEmoji];
    
    _btnflower = [[UIButton alloc]init];
    [_btnflower setTitle:@"小花" forState:UIControlStateNormal];
    _btnflower.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnflower setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnflower.backgroundColor = RGB3(179);
    [_vDownBg addSubview:_btnflower];
    
    _vHorLine = [[UIView alloc]init];
    _vHorLine.backgroundColor = [UIColor blackColor];
    _vHorLine.alpha = 0.3;
    [_vDownBg addSubview:_vHorLine];
    
    _vLineOne = [[UIView alloc]init];
    _vLineOne.backgroundColor = [UIColor blackColor];
    _vLineOne.alpha = 0.3;
    [_vDownBg addSubview:_vLineOne];
    
    _vLineTwo = [[UIView alloc]init];
    _vLineTwo.backgroundColor = [UIColor blackColor];
    _vLineTwo.alpha = 0.3;
    [_vDownBg addSubview:_vLineTwo];
}

- (void)sendAction{
    if ([self.delegate respondsToSelector:@selector(sendActionWithBtn)]) {
        [self.delegate sendActionWithBtn];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FaceCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDEN forIndexPath:indexPath];
    [cell loadData:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30, 30);
}

#pragma mark -  Header
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(DEVICEWIDTH, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FaceHeaderView *cell = (FaceHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CELLHeader forIndexPath:indexPath];
    cell.text = @"全部表情";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *face = [self.emojiDictionary objectAtIndex:indexPath.row];
    NSLog(@"%s__%d%@",__func__,__LINE__,face);
    if ([self.delegate respondsToSelector:@selector(selectFaceVoiw:)]) {
        [self.delegate selectFaceVoiw:face];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r = self.vTopBg.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = self.width;
    r.size.height = self.height - 40;
    self.vTopBg.frame = r;
    
    r = self.collView.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = self.vTopBg.width;
    r.size.height = self.vTopBg.height;
    self.collView.frame = r;
    
    
    r = self.vDownBg.frame;
    r.origin.x = 0;
    r.origin.y = self.height - 40;
    r.size.width = self.width;
    r.size.height = 40;
    self.vDownBg.frame = r;
    
    r = self.btnSend.frame;
    r.origin.x = self.width - 50*RATIO_WIDHT320;
    r.origin.y = 0;
    r.size.width = 50*RATIO_WIDHT320;
    r.size.height = self.vDownBg.height;
    self.btnSend.frame = r;
    
    CGFloat w = (self.width - self.btnSend.width - 2)/3.0;
    r = self.vHorLine.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = self.width - self.btnSend.width;
    r.size.height = 1;
    self.vHorLine.frame = r;
    
    r = self.btnDefault.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = w;
    r.size.height = self.vDownBg.height;
    self.btnDefault.frame = r;
    
    r = self.vLineOne.frame;
    r.origin.x = self.btnDefault.right;
    r.origin.y = 0;
    r.size.width = 1;
    r.size.height = self.vDownBg.height;
    self.vLineOne.frame = r;
    
    r = self.btnEmoji.frame;
    r.origin.x = self.vLineOne.right;
    r.origin.y = 0;
    r.size.width = w;
    r.size.height = self.vDownBg.height;
    self.btnEmoji.frame = r;
    
    r = self.vLineOne.frame;
    r.origin.x = self.btnDefault.right;
    r.origin.y = 0;
    r.size.width = 1;
    r.size.height = self.vDownBg.height;
    self.vLineOne.frame = r;
    
    r = self.btnflower.frame;
    r.origin.x = self.btnEmoji.right;
    r.origin.y = 0;
    r.size.width = w;
    r.size.height = self.vDownBg.height;
    self.btnflower.frame = r;
}

@end
