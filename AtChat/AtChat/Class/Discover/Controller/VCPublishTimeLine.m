//
//  VCPublishTimeLine.m
//  AtChat
//
//  Created by zhouMR on 2017/3/8.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "VCPublishTimeLine.h"
#import "CollCellTimeLinePic.h"
#import "CollCellTimeLineAdd.h"
#import "Photo.h"
#import "TimeLine.h"

@interface VCPublishTimeLine ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITextView *tvText;
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation VCPublishTimeLine

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVC];
}

- (void)initVC{
    self.dataSource = [NSMutableArray array];
    Photo *p = [[Photo alloc]init];
    p.type = TIMELINETYPEADD;
    [self.dataSource addObject:p];
    [self.view addSubview:self.tvText];
    
    [self.view addSubview:self.collView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
}

- (void)cancelAction{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)sendAction{
    [self.view endEditing:YES];
    NSString *content = [self.tvText.text stringByTrim];
    NSDictionary *params = @{@"method":@"publish",@"name":[XmppTools sharedManager].userName,@"url":@"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/imgad/pic/item/0ff41bd5ad6eddc4c301bc7931dbb6fd53663349.jpg",@"content":content};
    NSMutableArray *array = [NSMutableArray array];
    for (Photo *p in self.dataSource) {
        if (p.type == TIMELINETYPEPHOTO) {
            [array addObject:p.img];
        }
    }
    [[NetRequestTool shared] startMultiPartUploadTaskWithURL:@"apiMobile" imagesArray:array parametersDict:params compressionRatio:0.5 succeedBlock:^(NSDictionary *dict) {
        
    } failedBlock:^(NSError *error) {
        
    }];
    [self cancelAction];
}

- (CGFloat)calHeight{
    CGFloat w = [CollCellTimeLinePic calHeight];
    CGFloat sec = self.dataSource.count/4;
    if (self.dataSource.count %4 !=0) {
        sec += 1;
    }
    return w * sec + (sec-1) * 10;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Photo *data = [self.dataSource objectAtIndex:indexPath.row];
    if (data.type == TIMELINETYPEADD) {
        CollCellTimeLineAdd *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollCellTimeLineAdd" forIndexPath:indexPath];
        return cell;
    }else{
        CollCellTimeLinePic *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollCellTimeLinePic" forIndexPath:indexPath];
        [cell loadData:data];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = [CollCellTimeLinePic calHeight];
    return CGSizeMake(w, w);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[CollCellTimeLineAdd class]]) {
        //添加
        [self selectImg];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"这一刻的想法..."]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@""]){
        textView.text = @"这一刻的想法...";
        textView.textColor = RGB3(229);
    }
}

//选择图片
- (void)selectImg{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.dataSource.count > 0) {
        [self.dataSource removeLastObject];
    }
    
    Photo *p = [[Photo alloc]init];
    p.img = image;
    p.type = TIMELINETYPEPHOTO;
    [self.dataSource addObject:p];
    if (self.dataSource.count < 9) {
        Photo *p1 = [[Photo alloc]init];
        p1.type = TIMELINETYPEADD;
        [self.dataSource addObject:p1];
    }
    
    [self.collView reloadData];
    self.collView.height = [self calHeight];
}

- (UITextView*)tvText{
    if(!_tvText){
        _tvText = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, DEVICEWIDTH-20, 50)];
        _tvText.delegate = self;
        _tvText.text = @"这一刻的想法...";
        _tvText.textColor = RGB3(229);
    }
    return _tvText;
}

- (UICollectionView*)collView{
    if (!_collView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGRect r = CGRectMake(self.tvText.left, self.tvText.bottom + 15, self.tvText.width, [self calHeight]);
        _collView = [[UICollectionView alloc]initWithFrame:r collectionViewLayout:layout];
        [_collView registerClass:[CollCellTimeLinePic class] forCellWithReuseIdentifier:@"CollCellTimeLinePic"];
        [_collView registerClass:[CollCellTimeLineAdd class] forCellWithReuseIdentifier:@"CollCellTimeLineAdd"];
        _collView.delegate = self;
        _collView.dataSource = self;
        _collView.scrollEnabled = NO;
        _collView.backgroundColor = [UIColor clearColor];
    }
    return _collView;
}

@end
