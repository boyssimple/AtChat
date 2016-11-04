//
//  CellMeAction.h
//  LifeChat
//
//  Created by zhouMR on 16/5/10.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMeAction : UITableViewCell
@property (nonatomic, strong) UIImageView *ivIcon;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UIImageView *ivArrowRight;

- (void)updateData:(NSString *)title andIcon:(NSString*)icon;
@end
