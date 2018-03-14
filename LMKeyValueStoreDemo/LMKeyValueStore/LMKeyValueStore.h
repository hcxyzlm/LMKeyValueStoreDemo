//
//  LMKeyValueStore.h
//  LMKeyValueStoreDemo
//
//  Created by zhuo on 2018/3/14.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMKeyValueStore : NSObject

- (void)createTableWithName:(NSString *)tableName;

- (BOOL)isTableExists:(NSString *)tableName;

- (void)clearTable:(NSString *)tableName;

- (void)close;

///************************ insert&Get methods *****************************************

- (void)putCacheString:(NSString *)string withId:(NSString *)objectId intoTable:(NSString *)tableName;

- (NSString *)getCacheStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (id)getObjectStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (void)deletCacheStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (void)deleteAllCacheByTableName:(NSString *)tableName;

// 清楚缓存，这里并不是删除缓存，只是把缓存时间改成null值
- (void)markCacheExpiredById:(NSString *)stringId fromTable:(NSString *)tableName;

// 检查缓存是否过期，一般是24小时
-(BOOL)checkCacheValidById:(NSString *)stringId fromTable:(NSString *)tableName cacheDate:(NSTimeInterval)cacheDate;

@end
