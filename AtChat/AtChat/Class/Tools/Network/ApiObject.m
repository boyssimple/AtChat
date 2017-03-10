//
//  ApiObject.m
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "ApiObject.h"

@implementation ApiObject

- (instancetype)init{
    self = [super init];
    if (self) {
        _args = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString*)netRequstUrl{
    NSAssert(NO, @"subClass must implement the method: netRequstUrl");
    return @"";
}

- (NSMutableDictionary *)getArgs {
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
    [_args setObject:@(t) forKey:@"timestamp"];
    return _args;
}

- (NSString*)cacheIdentifierOfTable{
    return @"";
}

- (NSString*)cacheItemIdentifier{
    if(self.isCache)
    {
        NSAssert(NO, @"subClass must implement the method: -cacheItemIdentifier");
    }
    return @"";
}

- (void)parseObj:(NSDictionary*)obj{
    self.status = [obj boolValueForKey:@"status" default:FALSE];
    self.message = [obj stringValueForKey:@"message" default:@"请求失败"];
}

@end
