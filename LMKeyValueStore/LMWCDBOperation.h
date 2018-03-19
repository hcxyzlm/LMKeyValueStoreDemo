//
//  LMWCDBOperation.h
//  lazyaudio
//
//  Created by zhuo on 2018/1/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WCTDatabase;
@interface LMWCDBOperation : NSObject

@property (nonatomic, strong, readonly) WCTDatabase *dbDatabase;

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype )initDBWithName:(NSString *)dbName;

- (instancetype )initWithDBWithPath:(NSString *)dbPath;

#pragma mark insert
- (BOOL)insertObject:(NSObject *)object
                into:(NSString *)tableName;

#pragma mark - Get Object

/**
 从数据库查找model

 @param cls class
 @param tableName 表名
 @param columnName model id 对应绑定数据库的名称
 @param realID 实参，找到realID的模型，id类型只接受NSString和NSNumber类型，其他会报错
 */
- (id)getOneObjectOfClass:(Class)cls fromTable:(NSString *)tableName bandingColumnName:(NSString *)columnName realID:(id)realID;

#pragma mark Update With Object

/**
 根据传入id参数更新数据库

 @param tableName 表名
 @param object 更新的model
 @param columnName 绑定的数据库参数
 @param realID id类型只接受NSString和NSNumber类型，其他会报错
 */
- (BOOL)updateObjectInTable:(NSString *)tableName withObject:(NSObject *)object bandingColumnName:(NSString *)columnName realID:(id)realID;

#pragma mark delete object

/**
 从数据库删除模型

 @param tableName 表名
 @param columnName 绑定id对应数据库字段名
 @param realID id类型只接受NSString和NSNumber类型，其他会报错
 */
- (BOOL)deleteObjectFromTable:(NSString *)tableName bandingColumnName:(NSString *)columnName realID:(id)realID;

@end

NS_ASSUME_NONNULL_END
