//
//  CollCellTimeLinePic.h
//  AtChat
//
//  Created by zhouMR on 2017/3/8.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface CollCellTimeLinePic : UICollectionViewCell
- (void)loadData:(Photo*)data;
+ (CGFloat)calHeight;
@end
