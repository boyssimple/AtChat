//
//  Toast.m
//  AtChat
//
//  Created by zhouMR on 2017/3/8.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "Toast.h"

@implementation Toast
+ (void)show:(UIView*)vc withMsg:(NSString*)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:vc animated:YES];
    });
}
@end
