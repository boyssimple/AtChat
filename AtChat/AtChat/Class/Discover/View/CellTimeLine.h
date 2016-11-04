//
//  CellTimeLine.h
//  TimeLine
//
//  Created by zhouMR on 16/5/12.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLine.h"
@protocol CellTimeLineDelegate;
@interface CellTimeLine : UITableViewCell{
    BOOL isShowing;
}
- (void)updateData:(TimeLine*)data;
+ (CGFloat)calHeight:(TimeLine*)data;
@property (nonatomic, assign) id<CellTimeLineDelegate> delegate;
@end

@protocol CellTimeLineDelegate <NSObject>

@optional
- (void)selectImg:(UIImageView*)ivImg;

@end