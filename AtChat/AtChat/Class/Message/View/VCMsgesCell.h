//
//  VCMsgesCell.h
//  AtChat
//
//  Created by zhouMR on 16/11/2.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCMsgesCell : UITableViewCell
@property (nonatomic, strong) UIView  *vLine;
+ (CGFloat)calHeight;
- (void)updateData:(XMPPMessageArchiving_Contact_CoreDataObject*)data;
@end
