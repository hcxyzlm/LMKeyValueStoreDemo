//
//  LMWCDBOperation.m
//  lazyaudio
//
//  Created by zhuo on 2018/1/23.
//

#import "LMWCDBOperation.h"
#import <WCDB/WCDB.h>
#import "LMLog.h"

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface LMWCDBOperation ()

@property (nonatomic, strong, readwrite) WCTDatabase *dbDatabase;

@end

@implementation LMWCDBOperation

#pragma mark - Override

- (void)dealloc {
    
    [self.dbDatabase close];
}

#pragma mark - Public
- (instancetype )initDBWithName:(NSString *)dbName {
    self = [super init];
    if (self) {
        NSString * dbPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:dbName];
        self.dbDatabase = [[WCTDatabase alloc] initWithPath:dbPath];
        LMLog(@"database file path [%@]", dbPath);
        NSAssert(self.dbDatabase != nil , @"error dbDatabase create failed");

    }
    return self;
    
}

- (instancetype )initWithDBWithPath:(NSString *)dbPath {
    self = [super init];
    if (self) {
        self.dbDatabase = [[WCTDatabase alloc] initWithPath:dbPath];
        LMLog(@"database file path [%@]", dbPath);
        NSAssert(self.dbDatabase != nil , @"error dbDatabase create failed");
        
    }
    return self;
}
#pragma mark public

- (BOOL)isTableExists:(NSString *)tableName {
    return [self.dbDatabase isTableExists:tableName];
}

- (BOOL)createTableAndIndexesOfName:(NSString *)tableName withClass:(Class)cls {
    if (![cls conformsToProtocol:@protocol(WCTTableCoding)]) {
        LMLog(@"error, class is not implementation WCTTableCoding protocol");
        return NO;
    }
    
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        LMLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    
    return [self.dbDatabase createTableAndIndexesOfName:tableName withClass:cls];
}

#pragma mark public

- (BOOL)insertObject:(NSObject<WCTTableCoding> *)object
                into:(NSString *)tableName {
    if (![object conformsToProtocol:@protocol(WCTTableCoding)]) {
        LMLog(@"error, class is not implementation WCTTableCoding protocol");
        return NO;
    }
    
    WCTObject *obj = (WCTObject *)object;
    
    if (![self.dbDatabase isTableExists:tableName]) {
        [self.dbDatabase createTableAndIndexesOfName:tableName withClass:[obj class]];
    }
    
    return  [self.dbDatabase insertObject:obj into:tableName];
}

- (BOOL)insertOrReplaceObject:(NSObject<WCTTableCoding> *)object
                         into:(NSString *)tableName {
    
    if (![object conformsToProtocol:@protocol(WCTTableCoding)]) {
        LMLog(@"error, class is not implementation WCTTableCoding protocol");
        return NO;
    }
    
    WCTObject *obj = (WCTObject *)object;
    
    if (![self.dbDatabase isTableExists:tableName]) {
        [self.dbDatabase createTableAndIndexesOfName:tableName withClass:[obj class]];
    }
    
    return  [self.dbDatabase insertOrReplaceObject:obj into:tableName];
}

#pragma mark - Get Object

- (id)getOneObjectOfClass:(Class)cls fromTable:(NSString *)tableName primaryKeyName:(NSString *)keyName primaryKey:(id)key{
    
    if (!tableName.length || !keyName.length || !key) {
        LMLog(@"getOneObjectOfClass error, tableName  or primaryKeyName or primaryKey  is null");
        return nil;
    }
    NSAssert([key isKindOfClass:[NSString class]] || [key isKindOfClass:[NSNumber class]] , @"Data error");
    WCDB::Expr contindation(WCDB::Column(keyName.UTF8String));
    if ([key isKindOfClass:[NSString class]]) {
        NSString *str = key;
        contindation  = contindation == str.UTF8String;
    }else if ([key isKindOfClass:[NSNumber class]]) {
        contindation  = contindation == [key longLongValue];
    }
    
    return [self.dbDatabase getOneObjectOfClass:cls fromTable:tableName where:contindation];
}

#pragma mark Update With Object

- (BOOL)updateObjectInTable:(NSString *)tableName withObject:(NSObject<WCTTableCoding> *)object primaryKeyName:(NSString *)keyName primaryKey:(id)key {
    if (!tableName.length || !keyName.length || !key) {
        LMLog(@"updateObjectInTable error, tableName  or primaryKeyName or primaryKey  is null");
        return NO;
    }
    if (![object conformsToProtocol:@protocol(WCTTableCoding)]) {
        LMLog(@"error, class is not implementation WCTTableCoding protocol");
        return NO;
    }
    NSAssert([key isKindOfClass:[NSString class]] || [key isKindOfClass:[NSNumber class]] , @"Data error");
    
    WCTObject *obj = (WCTObject *)object;
    WCDB::Expr contindation(WCDB::Column(keyName.UTF8String));
    if ([key isKindOfClass:[NSString class]]) {
        NSString *str = key;
        contindation  = contindation == str.UTF8String;
    }else if ([key isKindOfClass:[NSNumber class]]) {
        contindation  = contindation == [key longLongValue];
    }
    
    return [self.dbDatabase updateRowsInTable:tableName onProperties:[obj.class AllProperties] withObject:obj where:contindation];
}

#pragma mark delete object

- (BOOL)deleteObjectFromTable:(NSString *)tableName primaryKeyName:(NSString *)keyName primaryKey:(id)key{
    
    if (!tableName.length || !keyName.length || !key) {
        LMLog(@"deleteObjectFromTable error, tableName  or primaryKeyName or primaryKey  is null");
        return NO;
    }
    
    NSAssert([key isKindOfClass:[NSString class]] || [key isKindOfClass:[NSNumber class]] , @"Data error");
    WCDB::Expr contindation(WCDB::Column(keyName.UTF8String));
    if ([key isKindOfClass:[NSString class]]) {
        NSString *str = key;
        contindation  = contindation == str.UTF8String;
    }else if ([key isKindOfClass:[NSNumber class]]) {
        contindation  = contindation == [key longLongValue];
    }
    return [self.dbDatabase deleteObjectsFromTable:tableName where:contindation];
}
#pragma mark - Private
@end
