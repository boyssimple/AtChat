//
//  TimeLineTest.m
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "TimeLineTest.h"

@implementation TimeLineData

- (id)init{
    self = [super init];
    if (self) {
        self.name = @"我是找幸福给你";
    }
    return self;
}

- (void)parseObj:(NSDictionary *)obj{
    self.name = [obj stringValueForKey:@"name" default:@""];
    self.url = [obj stringValueForKey:@"url" default:@""];
    self.content = [obj stringValueForKey:@"content" default:@""];
    self.time = [obj stringValueForKey:@"time" default:@""];
    self.images = [obj objectForKey:@"images"];
}
@end

@implementation TimeLineTest
- (instancetype)init{
    self = [super init];
    if (self) {
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)setInMethod:(NSString *)inMethod{
    _inMethod = inMethod;
    [self.args setObject:_inMethod forKey:@"method"];
}

- (NSString*)netRequstUrl{
    return @"apiMobile";
}

- (NSString*)cacheItemIdentifier{
    return [NSString stringWithFormat:@"page"];
}

- (void)parseObj:(NSDictionary *)obj{
    [super parseObj:obj];
    [self.datas removeAllObjects];
    NSArray *arr = [obj objectForKey:@"datas"];
    for (NSDictionary*d in arr) {
        TimeLineData *data = [[TimeLineData alloc]init];
        [data parseObj:d];
        [self.datas addObject:data];
    }
}
@end
