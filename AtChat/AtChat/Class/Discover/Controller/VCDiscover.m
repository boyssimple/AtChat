//
//  VCMeTab.m
//  LifeChat
//
//  Created by simple on 16/4/23.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "VCDiscover.h"
#import "CellDiscover.h"

#import "VCTimeline.h"
#import "HMScannerController.h"

@interface VCDiscover ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@end

@implementation VCDiscover

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{\
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"CellDiscover";
        CellDiscover *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CellDiscover alloc]init];
        }
        [cell updateData:@"朋友圈" andIcon:@"ff_IconShowAlbum"];
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            static NSString *identifier = @"CellMeAction";
            CellDiscover *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CellDiscover alloc]init];
            }
            [cell updateData:@"扫一扫" andIcon:@"ff_IconQRCode"];
            return cell;
        }else if(indexPath.row == 1){
            static NSString *identifier = @"CellMeAction";
            CellDiscover *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CellDiscover alloc]init];
            }
            [cell updateData:@"摇一摇" andIcon:@"ff_IconShake"];
            return cell;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            static NSString *identifier = @"CellMeAction";
            CellDiscover *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CellDiscover alloc]init];
            }
            [cell updateData:@"附近的人" andIcon:@"ff_IconLocationService"];
            return cell;
        }else if(indexPath.row == 1){
            static NSString *identifier = @"CellMeAction";
            CellDiscover *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CellDiscover alloc]init];
            }
            [cell updateData:@"漂流瓶" andIcon:@"ff_IconBottle"];
            return cell;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// 取消选中
    if (indexPath.section == 0) {
        VCTimeline *vc = [[VCTimeline alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:TRUE];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            HMScannerController *scanner = [HMScannerController scannerWithCardName:[XmppTools sharedManager].userName avatar:nil completion:^(NSString *stringValue) {
                NSLog(@"扫描到了：%@",stringValue);
            }];
            
            [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor whiteColor]];
            
            [self showDetailViewController:scanner sender:nil];
        }
    }
}

#pragma mark - geter seter
- (UITableView*)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}
@end
