//
//  VCTimeLine.m
//  TimeLine
//
//  Created by zhouMR on 16/5/11.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCTimeline.h"
#import "TimeLineHeader.h"
#import "CellTimeLine.h"
#import "TimeLine.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "VCPublishTimeLine.h"
#import "VCNavBase.h"
#import "TimeLineTest.h"
#import "ActionSheet.h"

@interface VCTimeline ()<CellTimeLineDelegate,UITableViewDelegate,UITableViewDataSource,TimeLineHeaderDelegate,
    ActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) TimeLineHeader *header;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) TimeLineTest *timeLine;
@end

@implementation VCTimeline

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
    self.dataSource = [[NSMutableArray alloc]init];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MakePhoto"] style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self loadNewData];
}

/**
 * 加载新数据
 */
- (void)loadNewData{
    self.timeLine.isLoadLocalCache = YES;
    [self loadData];
}

/**
 * 加载数据
 */
- (void)loadData{
    __weak typeof(self) weakself = self;
    [[NetRequestTool shared] requestPost:self.timeLine withSuccess:^(ApiObject *m) {
        NSLog(@"%s__%d|",__func__,__LINE__);
        TimeLineTest *t = (TimeLineTest*)m;
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:t.datas];
        [weakself.table reloadData];
        [weakself.table.mj_header endRefreshing];
    } withFailure:^(ApiObject *m) {
        NSLog(@"%s__%d|",__func__,__LINE__);
        [weakself.table.mj_header endRefreshing];
    }];
}

/**
 * 刷新
 */
- (void)refresh{
    self.timeLine.isLoadLocalCache = NO;
    [self loadData];
}

/**
 * 跳转到朋友圈发布
 */
- (void)publishAction{
    VCPublishTimeLine *vc = [[VCPublishTimeLine alloc]init];
    VCNavBase *nav = [[VCNavBase alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:TRUE completion:^{
        
    }];
}

//选择图片
- (void)selectImg{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


/**
 * 上传相册封面
 */
- (void)uploadImage:(UIImage *)image{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"处理中...";
    [[NetRequestTool shared] startMultiPartUploadTaskWithURL:@"apiMobileUpload" imagesArray:@[image] parametersDict:nil compressionRatio:0.3 succeedBlock:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Toast show:self.view withMsg:@"上传成功"];
    } failedBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Toast show:self.view withMsg:@"上传失败"];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimeLineData *line = [self.dataSource objectAtIndex:indexPath.row];
    return [CellTimeLine calHeight:line];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"CellTimeLine";
    CellTimeLine *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CellTimeLine alloc]init];
        cell.delegate = self;
    }
    cell.index = indexPath;
    TimeLineData *line = [self.dataSource objectAtIndex:indexPath.row];
    [cell updateData:line];
    return cell;
}

#pragma mark - CellTimeLineDelegate

- (void)selectImg:(NSArray*)images withIndex:(NSInteger)index withIndexPath:(NSIndexPath*)indexPath{
    TimeLineData *line = [self.dataSource objectAtIndex:indexPath.row];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i=0; i<images.count; i++) {
        UIView *v = images[i];
        if ([v isKindOfClass:[UIImageView class]]) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.srcImageView = (UIImageView*)v;
            if (line.images.count > i) {
                NSString *url = line.images[i];
                photo.url = [NSURL URLWithString:url];
            }
            [arr addObject:photo];
        }
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index;
    browser.photos = arr;
    [browser show];
}

#pragma mark - TimeLineHeaderDelegate
- (void)headerAction{
    ActionSheet *sheet = [[ActionSheet alloc]initWithActions:@[@{@"name":@"更新相册封面"}]];
    sheet.delegate = self;
    [sheet show];
}

#pragma mark - ActionSheetDelegate
- (void)actionSheetClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self selectImg];
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:image];
}

#pragma mark - geter seter

- (UITableView*)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT-NAV_STATUS_HEIGHT)];
        _table.dataSource = self;
        _table.delegate = self;
        _table.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.tableHeaderView = self.header;
        _table.showsVerticalScrollIndicator = NO;
        MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _table.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        
    }
    return _table;
}

- (TimeLineHeader*)header{
    if (!_header) {
        _header = [[TimeLineHeader alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, 290)];
        _header.delegate = self;
        [_header updateData];
    }
    return _header;
}

- (TimeLineTest*)timeLine{
    if (!_timeLine) {
        _timeLine = [[TimeLineTest alloc]init];
        _timeLine.isCache = YES;
        _timeLine.isReset = TRUE;
        _timeLine.inMethod = @"list";
        _timeLine.isLoadLocalCache = YES;
    }
    return _timeLine;
}
@end
