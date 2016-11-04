//
//  CellDiscover.h
//  LifeChat
//
//  Created by zhouMR on 16/5/18.
//  Copyright © 2016年 com.sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellDiscover : UITableViewCell
@property (nonatomic, strong) UIImageView *ivIcon;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UIImageView *ivArrowRight;

- (void)updateData:(NSString *)title andIcon:(NSString*)icon;

@end
