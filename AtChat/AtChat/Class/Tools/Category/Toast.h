//
//  Toast.h
//  AtChat
//
//  Created by zhouMR on 2017/3/8.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toast : NSObject
+ (void)show:(UIView*)vc withMsg:(NSString*)msg;
@end
