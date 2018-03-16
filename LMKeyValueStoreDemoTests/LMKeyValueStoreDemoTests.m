//
//  LMKeyValueStoreDemoTests.m
//  LMKeyValueStoreDemoTests
//
//  Created by zhuo on 2018/3/16.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LMKeyValueStore.h"
#import "LMWCDBOperation.h"
#import "LMKeyValueItem.h"

@interface LMKeyValueStoreDemoTests : XCTestCase

@end

@implementation LMKeyValueStoreDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    // 不存在会自动创建一个新的
    LMKeyValueStore *store = [[LMKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:@"test_table"];
    
    // insert
    NSString *tableName = @"test_table";
    NSString *key1 = @"key1";
    NSString *string = @"abc1";
    [store putCacheString:string withId:key1 intoTable:tableName];
    
    // select
    NSString *result = [store getCacheStringById:key1 fromTable:tableName];
    
    // 修改，使缓存过期
    [store makeCacheExpiredById:key1 fromTable:tableName];
    
    // delete
    [store deletCacheStringById:key1 fromTable:tableName];
    
    // delete all objcet
    [store deleteAllCacheByTableName:tableName];
}

- (void)testWCDBOpertaion {
    LMWCDBOperation *storeHelper = [[LMWCDBOperation alloc] initDBWithName:@"test.db"];
    NSString *tableName = @"test_table";
    LMKeyValueItem *item = [[LMKeyValueItem alloc] init];
    item.itemId = @"key1";
    item.itemObject = @"abc";
    item.createdTime = [NSDate date];
    
    // insert
    [storeHelper insertObject:item into:tableName];
    
    // select
    LMKeyValueItem *result = [storeHelper getOneObjectOfClass:[LMKeyValueItem class] fromTable:tableName bandingColumnName:@"id" realID:item.itemId];
    
    // modification
    item.itemObject = @"def";
    // bandingColumnName为oc的mm文件绑定到数据库的字段
    [storeHelper updateObjectInTable:tableName withObject:item bandingColumnName:@"id" realID:item.itemId];
    
    // delete
    [storeHelper deleteObjectFromTable:tableName bandingColumnName:@"id" realID:item.itemId];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
