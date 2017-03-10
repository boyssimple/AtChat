//
//  DataStoreManager.m
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import "DataStoreManager.h"

@implementation DataStoreManager
+ (DataStoreManager*)defatultDataStore{
    static DataStoreManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataStoreManager alloc]init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)tableNameFromApiObject:(ApiObject *)obj {
    NSString *tn = [[obj netRequstUrl] stringByReplacingOccurrencesOfString:@"/" withString:@""];//去掉非法字符
    tn = [NSString stringWithFormat:@"%@%@",tn,[obj cacheIdentifierOfTable]];
    return tn;
}

- (NSString *)itemKeyFromApiObject:(ApiObject *)obj {
    NSString *tn = [self tableNameFromApiObject:obj];
    NSString *ik = [NSString stringWithFormat:@"%@#||#%@",tn,[obj cacheItemIdentifier]];
    return ik;
}

- (BOOL)isCacheInvalid:(NSDate *)dt {
    
    NSDate *date = [NSDate date];
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    NSInteger interval = [destinationTimeZone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSTimeInterval t = [localeDate timeIntervalSinceDate:dt];
    int r = arc4random()%5 + 3;
    long space = r*3600;
    if(t<space)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 * 加载缓存数据
 */
- (id)loadCacheData:(ApiObject*)obj{
    NSString *tableName = [self tableNameFromApiObject:obj];
    NSString *itemKey = [self itemKeyFromApiObject:obj];
    DataStoreItem *item = [self getYTKKeyValueItemById:itemKey fromTable:tableName];
    if(![self isCacheInvalid:item.createdTime])
    {
        return nil;
    }
    else
    {
        return item.itemObject;
    }
    return nil;
}

/**
 * 重置后缓存数据
 */
- (void)resetAndCacheData:(id)json withTableIdentifier:(ApiObject*)identifier{
    NSString *tableName = [self tableNameFromApiObject:identifier];
    NSString *itemKey = [self itemKeyFromApiObject:identifier];
    [self clearTable:tableName];
    [self createTableWithName:tableName];
    [self putObject:json withId:itemKey intoTable:tableName];
}

/**
 * 缓存数据
 */
- (void)cacheData:(id)json withTableIdentifier:(ApiObject*)identifier{
    NSString *tableName = [self tableNameFromApiObject:identifier];
    NSString *itemKey = [self itemKeyFromApiObject:identifier];
    [self createTableWithName:tableName];
    [self putObject:json withId:itemKey intoTable:tableName];
}
@end
