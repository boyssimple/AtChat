//
//  TimeLineHeader.h
//  TimeLine
//
//  Created by zhouMR on 16/5/12.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TimeLineHeaderDelegate;
@interface TimeLineHeader : UIView
@property (nonatomic, strong) UIImageView *ivBg;
@property (nonatomic, strong) UIImageView *ivImg;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, weak)   id<TimeLineHeaderDelegate> delegate;
- (void)updateData;
@end

@protocol TimeLineHeaderDelegate <NSObject>

- (void)headerAction;

@end
