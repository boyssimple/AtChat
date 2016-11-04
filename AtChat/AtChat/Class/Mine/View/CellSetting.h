//
//  CellSetting.h
//  LifeChat
//
//  Created by zhouMR on 16/5/10.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CellSetting : UITableViewCell
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbRightText;
@property (nonatomic, strong) UIImageView *ivArrowRight;
@property (nonatomic, assign) int type;

-(void)updateData:(NSString *)name withRightText:(NSString*)text withType:(int)type;
@end
