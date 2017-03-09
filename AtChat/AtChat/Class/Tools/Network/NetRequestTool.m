//
//  NetRequestTool.m
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "NetRequestTool.h"
#import "DataStoreManager.h"

@implementation NetRequestTool

+ (NetRequestTool*)shared{
    static NetRequestTool *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[NetRequestTool alloc]init];
    });
    return request;
}

-(instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:BASEURL]];
    if(self)
    {
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}


-(void)requestPost:(ApiObject*)obj withSuccess:(void (^)(ApiObject *m))success withFailure:(void(^)(ApiObject *m))failure{
    
    NSAssert(obj, @"API 对象不能为nil");
    NSAssert([[obj netRequstUrl] isNotBlank], @"API URL 为空,请检查");
    //如果先加载缓存数据，则取出缓存数据 
    if(obj.isLoadLocalCache){
        id dbObj = [[DataStoreManager defatultDataStore] loadCacheData:obj];
        if(dbObj)
        {
            if(success)
            {
                [obj parseObj:dbObj];
                success(obj);
            }
            return;
        }
    }else{
        
        [self POST:[obj netRequstUrl] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"返回值\n------------------%@----------------------------⌵\n%@\n-----------------------------------------------------------------^\n\n",[obj netRequstUrl],[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            if([obj respondsToSelector:@selector(parseObj:)]){
                id json = [self parseJson:responseObject];
                if (json) {
                    [obj parseObj:json];
                    if(obj.isCache){
                        if (obj.isReset) {
                            [[DataStoreManager defatultDataStore] resetAndCacheData:json withTableIdentifier:obj];
                        }else{
                            [[DataStoreManager defatultDataStore] cacheData:json withTableIdentifier:obj];
                        }
                    }
                    if (obj.status) {
                        if(success){
                            success(obj);
                        }
                    }else{
                        if (failure) {
                            failure(obj);
                        }
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);  //这里打印错误信息
            obj.message = @"网络状况异常";
            if (failure) {
                failure(obj);
            }
        }];
    }
}

-(void)requestGet:(ApiObject*)obj withSuccess:(void (^)(ApiObject *m))success withFailure:(void(^)(ApiObject *m))failure{

}

- (id)parseJson:(id)data
{
    NSError *error = nil;
    NSObject *json = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableLeaves error:&error];
    id dicJson;
    if (error) {
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\nerror:%@\n 返回数据:%@",error,str);
        return nil;
    }
    else
    {
        if([json isKindOfClass:[NSArray class]])
        {
            dicJson=(NSArray *)json;
        }
        else
        {
            dicJson=(NSDictionary *)json;
        }
        return dicJson;
    }
    NSAssert([dicJson isKindOfClass:[NSDictionary class]], @"返回数据类型在ApiRequest-parseJson中不能转为字典");
    return nil;
}

@end
