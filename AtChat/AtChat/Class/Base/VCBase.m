//
//  VCBase.m
//  AtChat
//
//  Created by zhouMR on 16/11/1.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "VCBase.h"

@interface VCBase ()

@end

@implementation VCBase

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"__%@__",[[self class] className]);
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
