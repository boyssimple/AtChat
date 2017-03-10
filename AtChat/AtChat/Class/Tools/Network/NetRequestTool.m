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
        }else{
            [self loadData:obj withSuccess:success withFailure:failure];
        }
    }else{
        [self loadData:obj withSuccess:success withFailure:failure];
    }
}

- (void)loadData:(ApiObject*)obj withSuccess:(void (^)(ApiObject *m))success withFailure:(void(^)(ApiObject *m))failure{
    [self POST:[obj netRequstUrl] parameters:[obj getArgs] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

-(void)requestGet:(ApiObject*)obj withSuccess:(void (^)(ApiObject *m))success withFailure:(void(^)(ApiObject *m))failure{

}

/**
 * 上传图片
 */
-(void)startMultiPartUploadTaskWithURL:(NSString *)url imagesArray:(NSArray *)images parametersDict:(NSDictionary *)parameters compressionRatio:(float)ratio succeedBlock:(void (^)(NSDictionary *dict))success failedBlock:(void (^)(NSError *error))failure{
    if (images.count == 0) {
        NSLog(@"图片数组计数为零");
        return;
    }
    for (int i = 0; i < images.count; i++) {
        if (![images[i] isKindOfClass:[UIImage class]]) {
            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
        }
    }
    
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        //根据当前系统时间生成图片名称
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMddhhmmsss"];
        
        NSDate *date = [NSDate date];
        NSString *dateString = [formatter stringFromDate:date];
        for (UIImage *image in images) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i++];
            NSLog(@"图片:%@",fileName);
            NSData *imageData;
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }else{
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }
            [formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"5959595959=%@=",newStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"5959595959=上传失败");
        }
    }];
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
