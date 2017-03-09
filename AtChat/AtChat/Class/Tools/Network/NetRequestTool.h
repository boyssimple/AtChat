//
//  NetRequestTool.h
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"

@interface NetRequestTool : AFHTTPSessionManager
+ (NetRequestTool *)shared;
-(void)requestPost:(ApiObject*)obj withSuccess:(void (^)(ApiObject *m))success withFailure:(void(^)(ApiObject *m))failure;
-(void)requestGet:(ApiObject*)obj withSuccess:(void (^)(ApiObject *m))success withFailure:(void(^)(ApiObject *m))failure;
@end
