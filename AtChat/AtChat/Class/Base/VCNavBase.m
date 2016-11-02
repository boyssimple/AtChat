//
//  VCNavBase.m
//  LifeChat
//
//  Created by zhouMR on 16/5/6.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import "VCNavBase.h"

@interface VCNavBase ()

@end

@implementation VCNavBase

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBar.barTintColor = BASE_COLOR;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];

    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict= [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
}

@end
