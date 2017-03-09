//
//  NetTool.m
//  haochang
//
//  Created by zhouMR on 16/7/1.
//  Copyright © 2016年 luowei. All rights reserved.
//

#import "NetTool.h"

@implementation NetTool
+(void)requestPostWith:(NSString*)url withParams:(NSDictionary*)params andblock:(void (^)(NSDictionary *dic, NSError *error))block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASEURL,url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"这里打印请求成功要做的事:%@",responseObject);
        if (block) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);  //这里打印错误信息
        if (block) {
            block(nil, error);
        }
    }];
}

+(void)requestGetWith:(NSString*)url andblock:(void (^)(NSDictionary *dic, NSError *error))block{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 添加这句代码
    [manager GET:[NSString stringWithFormat:@"%@%@",BASEURL,url] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
        NSLog(@"这里打印请求成功要做的事:%@",responseObject);
        if (block) {
            block(responseObject, nil);
        }
    }
     
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
        NSLog(@"%@",error);  //这里打印错误信息
        if (block) {
            block(nil, error);
        }
             
    }];
}
@end
