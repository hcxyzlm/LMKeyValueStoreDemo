
LMKeyValueStore demo 有问题，有疑问欢迎加QQ：601113614

LMKeyValueStore是基于WCDB databas一套缓存框工具。支持网络json缓存

About WCDB : [Tencent/WCDB](https://github.com/Tencent/wcdb) , [微信WCDB进化之路 - 开源与开始](https://mp.weixin.qq.com/s?__biz=MzAwNDY1ODY2OQ%3D%3D&mid=2649286603&idx=1&sn=d243dd27f2c6614631241cd00570e853&chksm=8334c349b4434a5fd81809d656bfad6072f075d098cb5663a85823e94fc2363edd28758ab882&mpshare=1&scene=1&srcid=0609GLAeaGGmI4zCHTc2U9ZX)

## 集成说明
你可以在 Podfile 中加入下面一行代码来使用YTKKeyValueStore
```
  pod "LMKeyValueStore"
```

## 使用教程
缓存json的封装类为LMKeyValueStore

### 打开（或创建）数据库
```objc-c
LMKeyValueStore *store = [[LMKeyValueStore alloc] initDBWithName:@"test.db"];
````

### 创建表
```objc-c
[store createTableWithName:@"test_table"];
```

### 操作数据库
```objc
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
```

## 封装wcdb操作类
 为了隔离c++的代码，不让引用wcdb引用的文件变成mm文件，特地封装了一个wcdb类，进行简单的数据库操作
接口都封装在LMWCDBOperation，然后更为复杂的数据库操作逻辑建议放在一个分类里面做更为合适

### 使用教程
```objc
 LMWCDBOperation *storeHelper = [[LMWCDBOperation alloc] initDBWithName:@"test.db"];
    NSString *tableName = @"test_table";
    LMKeyValueItem *item = [[LMKeyValueItem alloc] init];
    item.itemId = @"key1";
    item.itemObject = @"abc";
    item.createdTime = [NSDate date];
    
    //create
    if (![storeHelper isTableExists:tableName]) {
        [storeHelper createTableAndIndexesOfName:tableName withClass:[LMKeyValueItem class]];
    }
    
    // insert
    [storeHelper insertObject:item into:tableName];
    
    // select
    LLMKeyValueItem *result = [storeHelper getOneObjectOfClass:[LMKeyValueItem class] fromTable:tableName primaryKeyName:@"id" primaryKey:item.itemId];
    
    // modification
    item.itemObject = @"def";
    [storeHelper updateObjectInTable:tableName withObject:item primaryKeyName:@"id" primaryKey:item.itemId];
    
    // delete
    [storeHelper deleteObjectFromTable:tableName primaryKeyName:@"id" primaryKey:item.itemId];
```
