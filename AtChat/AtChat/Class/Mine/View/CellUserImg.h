//
//  CellUserImg.h
//  LifeChat
//
//  Created by zhouMR on 16/5/9.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellUserImg : UITableViewCell
@property (nonatomic, strong) UIImageView *ivImg;
@property (nonatomic, strong) UILabel *lbName;

-(void)updateData:(NSString*)userId;
@end
