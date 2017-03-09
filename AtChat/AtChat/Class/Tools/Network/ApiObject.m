//
//  ApiObject.m
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "ApiObject.h"

@implementation ApiObject

- (NSString*)netRequstUrl{
    NSAssert(NO, @"subClass must implement the method: netRequstUrl");
    return @"";
}

- (NSString*)cacheIdentifier{
    if(self.isCache)
    {
        NSAssert(NO, @"subClass must implement the method: -cacheIdentifier");
    }
    return @"";
}

- (void)parseObj:(NSDictionary*)obj{
    self.status = [obj boolValueForKey:@"status" default:FALSE];
    self.message = [obj stringValueForKey:@"message" default:@"请求失败"];
}

@end
