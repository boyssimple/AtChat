//
//  VCPhoto.h
//  AtChat
//
//  Created by zhouMR on 2017/3/7.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,OPERATIONIMAGE) {
    OPERATIONIMAGESELECT,
    OPERATIONIMAGEMAKEPHOTO
};

@interface VCPhoto : VCBase
@property (nonatomic, assign) OPERATIONIMAGE operation;
@end
