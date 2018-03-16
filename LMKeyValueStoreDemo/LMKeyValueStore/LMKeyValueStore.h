//
//  LMKeyValueStore.h
//  LMKeyValueStoreDemo
//
//  Created by zhuo on 2018/3/14.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LMKeyValueStore : NSObject

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype )initDBWithName:(NSString *)dbName;

- (instancetype )initWithDBWithPath:(NSString *)dbPath;


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

// 清除缓存，这里并不是删除缓存，只是把缓存时间改成null值
- (void)makeCacheExpiredById:(NSString *)stringId fromTable:(NSString *)tableName;

// 检查缓存是否过期，一般是24小时
-(BOOL)checkCacheValidById:(NSString *)stringId fromTable:(NSString *)tableName cacheDate:(NSTimeInterval)cacheDate;

@end
NS_ASSUME_NONNULL_END
