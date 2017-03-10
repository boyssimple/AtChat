//
//  ApiObject.h
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiObject : NSObject
@property (nonatomic,strong) NSMutableDictionary *args;
@property (nonatomic,assign)  BOOL      status;
@property (nonatomic, strong) NSString *message;
/**参数**/
@property (nonatomic,assign)  BOOL      isCache;        //是否缓存
@property (nonatomic,assign)  BOOL      isReset;        //是否重置    ####比如新数据和分页的数据
@property (nonatomic,assign)  BOOL      isLoadLocalCache;//是否首先加载本地缓存数据
- (NSMutableDictionary *)getArgs;
- (NSString*)netRequstUrl;                  //网络请求URL
- (NSString*)cacheIdentifierOfTable;               //缓存唯一标识
- (NSString*)cacheItemIdentifier;
- (void)parseObj:(NSDictionary*)obj;        //解析
@end
