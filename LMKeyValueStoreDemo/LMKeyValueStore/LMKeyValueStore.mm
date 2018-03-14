//
//  LMKeyValueStore.m
//  LMKeyValueStoreDemo
//
//  Created by zhuo on 2018/3/14.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import "LMKeyValueStore.h"
#import "LMWCDBOperation.h"
#import "LMLog.h"
#import <WCDB/WCDB.h>
#import "LMKeyValueItem.h"
#import "LMKeyValueItem+WCTTableCoding.h"

@interface LMKeyValueStore ()
@property (nonatomic, strong) LMWCDBOperation *dbOperation; //数据库句柄
@end

@implementation LMKeyValueStore
+ (BOOL)checkString:(NSString *)string {
    if (string == nil || string.length == 0 || [string rangeOfString:@" "].location != NSNotFound) {
       
        return NO;
    }
    return YES;
}

+ (BOOL)checkTableName:(NSString *)tableName {
    if (![LMKeyValueStore checkString:tableName] ){
        LMLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}

#pragma mark public
- (void)createTableWithName:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    if ([self isTableExists:tableName]) {
        return;
    }
    BOOL result = [self.dbOperation.dbDatabase createVirtualTableOfName:tableName withClass:[LMKeyValueItem class] ];
    if (!result) {
        LMLog(@"ERROR, table name: %@ create failued", tableName);
        return;
    }
}

- (BOOL)isTableExists:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return NO;
    }
    
    return [self.dbOperation.dbDatabase isTableExists:tableName];
}

- (void)clearTable:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    
    BOOL result =  [self.dbOperation.dbDatabase dropTableOfName:tableName];
    if (!result) {
        LMLog(@"ERROR, table name: %@ delete failued", tableName);
        return;
    }
}

- (void)close {
    if (self.dbOperation) {
        [self.dbOperation.dbDatabase close];
    }
}

- (void)putCacheString:(NSString *)string withId:(NSString *)objectId intoTable:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    if ([LMKeyValueStore checkString:string] == NO) {
        return;
    }
    
    if ([LMKeyValueStore checkString:objectId] == NO) {
        return;
    }
    
    if (![self isTableExists:tableName]) {
        
        [self createTableWithName:tableName];
    }
    
    LMKeyValueItem *keyValueItem = [[LMKeyValueItem alloc] init];
    keyValueItem.itemId = objectId;
    keyValueItem.itemObject = string;
    keyValueItem.createdTime = [NSDate date];
    [[LMWCDBOperation shareOperation].dbDatabase insertObject:keyValueItem into:tableName];
}

- (NSString *)getCacheStringById:(NSString *)stringId fromTable:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return nil;
    }
    if ([LMKeyValueStore checkString:stringId] == NO) {
        return nil;
    }
    
    LMKeyValueItem *keyValueItem = [[LMWCDBOperation shareOperation].dbDatabase getOneObjectOfClass:[LMKeyValueItem class] fromTable:tableName where:LMKeyValueItem.itemId == stringId];
    
    return keyValueItem.itemObject;
}

- (id)getObjectStringById:(NSString *)stringId fromTable:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return nil;
    }
    if ([LMKeyValueStore checkString:stringId] == NO) {
        return nil;
    }
    
    LMKeyValueItem *keyValueItem = [[LMWCDBOperation shareOperation].dbDatabase getOneObjectOfClass:[LMKeyValueItem class] fromTable:tableName where:LMKeyValueItem.itemId == stringId];
    return keyValueItem;
    
}

- (void)deletCacheStringById:(NSString *)stringId fromTable:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return ;
    }
    if ([LMKeyValueStore checkString:stringId] == NO) {
        return;
    }
    [self.dbOperation.dbDatabase deleteObjectsFromTable:tableName where:LMKeyValueItem.itemId == stringId];
}

- (void)deleteAllCacheByTableName:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return ;
    }
    [self.dbOperation.dbDatabase deleteAllObjectsFromTable:tableName];
}

- (void)markCacheExpiredById:(NSString *)stringId fromTable:(NSString *)tableName {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return ;
    }
    if ([LMKeyValueStore checkString:stringId] == NO) {
        return;
    }
    LMKeyValueItem *keyValueItem = [[LMKeyValueItem alloc] init];
    keyValueItem.createdTime = 0;
    
    [self.dbOperation.dbDatabase updateRowsInTable:tableName onProperty:LMKeyValueItem.createdTime withObject:keyValueItem where:LMKeyValueItem.itemId == stringId];
}

-(BOOL)checkCacheValidById:(NSString *)stringId fromTable:(NSString *)tableName cacheDate:(NSTimeInterval)cacheDate {
    if ([LMKeyValueStore checkTableName:tableName] == NO) {
        return NO;
    }
    if ([LMKeyValueStore checkString:stringId] == NO) {
        return NO;
    }
    
    NSDate * now = [NSDate date];
    LMKeyValueItem *item = [self getObjectStringById:stringId fromTable:tableName];
    if (!item ||
        ([now timeIntervalSinceDate:item.createdTime] >= cacheDate) ||
        [item.createdTime isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
        return NO;
    }
    
    return YES;
}
@end
