//
//  DataStoreManager.h
//  AtChat
//
//  Created by zhouMR on 2017/3/9.
//  Copyright © 2017年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStore.h"

@interface DataStoreManager : DataStore
+ (DataStoreManager*)defatultDataStore;
- (id)loadCacheData:(ApiObject*)obj;
- (void)resetAndCacheData:(id)json withTableIdentifier:(ApiObject*)identifier;
- (void)cacheData:(id)json withTableIdentifier:(ApiObject*)identifier;
@end
