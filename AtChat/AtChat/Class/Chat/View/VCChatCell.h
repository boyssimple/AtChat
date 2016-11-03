//
//  VCChatCell.h
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface VCChatCell : UITableViewCell

-(void)loadData:(Message *)msg;
+ (CGFloat)calHeight:(Message *)msg;
@end
