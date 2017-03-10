//
//  TimeLineTest.h
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "ApiObject.h"
@interface TimeLineData : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray  *images;
@property (nonatomic, strong) NSString  *time;
- (void)parseObj:(NSDictionary *)obj;
@end
@interface TimeLineTest : ApiObject
@property (nonatomic, strong) NSString *inMethod;
@property (nonatomic, strong) NSMutableArray *datas;
@end
