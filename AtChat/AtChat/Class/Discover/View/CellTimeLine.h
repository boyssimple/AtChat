//
//  CellTimeLine.h
//  TimeLine
//
//  Created by zhouMR on 16/5/12.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineTest.h"
@protocol CellTimeLineDelegate;
@interface CellTimeLine : UITableViewCell{
    BOOL isShowing;
}
- (void)updateData:(TimeLineData*)data;
+ (CGFloat)calHeight:(TimeLineData*)data;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, assign) id<CellTimeLineDelegate> delegate;
@end

@protocol CellTimeLineDelegate <NSObject>

@optional
- (void)selectImg:(NSArray*)images withIndex:(NSInteger)index withIndexPath:(NSIndexPath*)indexPath;

@end
