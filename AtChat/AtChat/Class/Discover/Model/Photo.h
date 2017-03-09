//
//  Photo.h
//  AtChat
//
//  Created by zhouMR on 2017/3/8.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,TIMELINETYPE){
    TIMELINETYPEPHOTO,
    TIMELINETYPEADD
};
@interface Photo : NSObject
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, assign) TIMELINETYPE type;
@end
