//
//  VCMessages.m
//  AtChat
//
//  Created by zhouMR on 16/11/1.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCMessages.h"
#import "VCMsgesCell.h"

@interface VCMessages ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@end

@implementation VCMessages

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [VCMsgesCell calHeight];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VCMsgesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VCMsgesCell"];
    [cell updateData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (UITableView*)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT-NAV_STATUS_HEIGHT) style:UITableViewStylePlain];
        [_table registerClass:[VCMsgesCell class] forCellReuseIdentifier:@"VCMsgesCell"];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

@end
