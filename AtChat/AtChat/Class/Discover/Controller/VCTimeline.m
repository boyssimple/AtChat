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

@interface VCTimeline ()<CellTimeLineDelegate,UITableViewDelegate,UITableViewDataSource>
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
    TimeLine *t1 = [[TimeLine alloc]init];
    NSArray *images = [[NSArray alloc]initWithObjects:@"http://photocdn.sohu.com/20151124/mp43786429_1448294862260_4.jpeg",
                       @"http://e.hiphotos.baidu.com/image/pic/item/5bafa40f4bfbfbedef57ab457ff0f736afc31ff9.jpg", nil];
    t1.images = images;
    [self.dataSource addObject:t1];
    
    TimeLine *t2 = [[TimeLine alloc]init];
    NSArray *images1 = [[NSArray alloc]initWithObjects:@"http://photocdn.sohu.com/20151124/mp43786429_1448294862260_4.jpeg",
                        @"http://e.hiphotos.baidu.com/image/pic/item/5bafa40f4bfbfbedef57ab457ff0f736afc31ff9.jpg", nil];
    t2.images = images1;
    [self.dataSource addObject:t2];
    
    
    TimeLine *t3 = [[TimeLine alloc]init];
    NSArray *images2 = [[NSArray alloc]initWithObjects:@"http://photocdn.sohu.com/20151124/mp43786429_1448294862260_4.jpeg",
                        @"http://e.hiphotos.baidu.com/image/pic/item/5bafa40f4bfbfbedef57ab457ff0f736afc31ff9.jpg",
                        @"http://f.hiphotos.baidu.com/image/pic/item/503d269759ee3d6dd0bd1af144166d224f4ade95.jpg",
                        @"http://h.hiphotos.baidu.com/image/pic/item/faedab64034f78f0b00507c97e310a55b3191cf9.jpg", nil];
    t3.images = images2;
    [self.dataSource addObject:t3];
    
    
    TimeLine *t4 = [[TimeLine alloc]init];
    NSArray *images3 = [[NSArray alloc]initWithObjects:@"http://photocdn.sohu.com/20151124/mp43786429_1448294862260_4.jpeg", nil];
    t4.images = images3;
    [self.dataSource addObject:t4];
    
    
    TimeLine *t5 = [[TimeLine alloc]init];
    NSArray *images4 = [[NSArray alloc]initWithObjects:@"http://photocdn.sohu.com/20151124/mp43786429_1448294862260_4.jpeg",
                        @"http://e.hiphotos.baidu.com/image/pic/item/5bafa40f4bfbfbedef57ab457ff0f736afc31ff9.jpg",
                        @"http://f.hiphotos.baidu.com/image/pic/item/503d269759ee3d6dd0bd1af144166d224f4ade95.jpg",
                        @"http://h.hiphotos.baidu.com/image/pic/item/faedab64034f78f0b00507c97e310a55b3191cf9.jpg",
                        @"http://e.hiphotos.baidu.com/image/pic/item/0df3d7ca7bcb0a46660716036c63f6246b60afe7.jpg",
                        @"http://b.hiphotos.baidu.com/image/pic/item/91529822720e0cf346d2d3c10d46f21fbe09aae7.jpg",
                        @"http://h.hiphotos.baidu.com/image/pic/item/0b46f21fbe096b63613cc36a0b338744ebf8ace7.jpg",
                        @"http://g.hiphotos.baidu.com/image/pic/item/8c1001e93901213f7606d3e653e736d12f2e95d7.jpg", nil];
    t5.images = images4;
    [self.dataSource addObject:t5];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MakePhoto"] style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    [self loadData];
}

- (void)loadData{
    [[NetRequestTool shared] requestPost:self.timeLine withSuccess:^(ApiObject *m) {
        NSLog(@"%s__%d|",__func__,__LINE__);
    } withFailure:^(ApiObject *m) {
        NSLog(@"%s__%d|",__func__,__LINE__);
    }];
}

- (void)publishAction{
    VCPublishTimeLine *vc = [[VCPublishTimeLine alloc]init];
    VCNavBase *nav = [[VCNavBase alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:TRUE completion:^{
        
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimeLine *line = [self.dataSource objectAtIndex:indexPath.row];
    return [CellTimeLine calHeight:line];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"CellTimeLine";
    CellTimeLine *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CellTimeLine alloc]init];
        cell.delegate = self;
    }
    TimeLine *line = [self.dataSource objectAtIndex:indexPath.row];
    [cell updateData:line];
    return cell;
}

#pragma mark - CellTimeLineDelegate

- (void)selectImg:(UIImageView *)ivImg{
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.srcImageView = ivImg;
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = @[photo];
    [browser show];
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
    }
    return _table;
}

- (TimeLineHeader*)header{
    if (!_header) {
        _header = [[TimeLineHeader alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, 290)];
        [_header updateData];
    }
    return _header;
}

- (TimeLineTest*)timeLine{
    if (!_timeLine) {
        _timeLine = [[TimeLineTest alloc]init];
    }
    return _timeLine;
}
@end
