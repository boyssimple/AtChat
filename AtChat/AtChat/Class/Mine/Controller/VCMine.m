//
//  VCMeTab.m
//  LifeChat
//
//  Created by simple on 16/4/23.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "VCMine.h"
#import "VCQr.h"
#import "VCSetting.h"

#import "CellUserImg.h"
#import "CellMeAction.h"

@interface VCMine ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@end

@implementation VCMine

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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{\
    if (indexPath.section == 0) {
        return 70*RATIO_WIDHT320;
    }else{
        return 40*RATIO_WIDHT320;
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
        static NSString *identifier = @"CellUserImg";
        CellUserImg *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CellUserImg alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell updateData:[XmppTools sharedManager].userName];
        return cell;
        
    }else if (indexPath.section == 1){
        static NSString *identifier = @"CellMeAction";
        CellMeAction *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CellMeAction alloc]init];
        }
        [cell updateData:@"我的二维码" andIcon:@"QrIcon"];
        return cell;
    }else if (indexPath.section == 2){
        static NSString *identifier = @"CellMeAction";
        CellMeAction *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CellMeAction alloc]init];
        }
        [cell updateData:@"设置" andIcon:@"SettingIcon"];
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// 取消选中
    
    if (indexPath.section == 1) {
        VCQr *vc = [[VCQr alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:TRUE];
    }else if (indexPath.section == 2) {
        VCSetting *vc = [[VCSetting alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:TRUE];
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
