//
//  TimeLine.m
//  TimeLine
//
//  Created by zhouMR on 16/5/12.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "TimeLine.h"

@implementation TimeLine
- (id)init{
    self = [super init];
    if (self) {
        self.name = @"我是找幸福给你";
        self.content = @"RGB转16进制工具具用于将RGB颜色值与十六进制字符串相互转换,工具使用简单,你只需要在以下三个输入框:红(R)、绿(G)、蓝(B)中输入RGB的颜色值及会自动回转换十";
        self.time = @"17分钟前";
    }
    return self;
}
@end
