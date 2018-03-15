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

@property (nonatomic, strong) NSString *dbFilePath;
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
        LMLog(@"database file path [%@]", _dbFilePath);
        NSAssert(self.dbDatabase != nil , @"error dbDatabase create failed");

    }
    return self;
    
}

- (instancetype )initWithDBWithPath:(NSString *)dbPath {
    self = [super init];
    if (self) {
        self.dbDatabase = [[WCTDatabase alloc] initWithPath:dbPath];
        LMLog(@"database file path [%@]", _dbFilePath);
        NSAssert(self.dbDatabase != nil , @"error dbDatabase create failed");
        
    }
    return self;
}
#pragma mark public

- (BOOL)insertObject:(NSObject *)object
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

#pragma mark - Get Object
- (id)getOneObjectOfClass:(Class)cls fromTable:(NSString *)tableName bandingColumnName:(NSString *)columnName realID:(id)realID{
    
    if (!tableName.length || !columnName.length) {
        LMLog(@"getOneObjectOfClass error, tableName  or columnName is null");
        return nil;
    }
    NSAssert([realID isKindOfClass:[NSString class]] || [realID isKindOfClass:[NSNumber class]] , @"Data error");
    WCDB::Expr contindation(WCDB::Column(columnName.UTF8String));
    if ([realID isKindOfClass:[NSString class]]) {
        NSString *str = realID;
        contindation  = contindation == str.UTF8String;
    }else if ([realID isKindOfClass:[NSNumber class]]) {
        contindation  = contindation == [realID longLongValue];
    }
    
    return [self.dbDatabase getOneObjectOfClass:cls fromTable:tableName where:contindation];
}

#pragma mark Update With Object
- (BOOL)updateObjectInTable:(NSString *)tableName withObject:(NSObject *)object bandingColumnName:(NSString *)columnName realID:(id)realID {
    if (!tableName.length || !columnName.length) {
        LMLog(@"updateObjectInTable error, tableName  or columnName is null");
        return NO;
    }
    if (![object conformsToProtocol:@protocol(WCTTableCoding)]) {
        LMLog(@"error, class is not implementation WCTTableCoding protocol");
        return NO;
    }
    NSAssert([realID isKindOfClass:[NSString class]] || [realID isKindOfClass:[NSNumber class]] , @"Data error");
    
    WCTObject *obj = (WCTObject *)object;
    WCDB::Expr contindation(WCDB::Column(columnName.UTF8String));
    if ([realID isKindOfClass:[NSString class]]) {
        NSString *str = realID;
        contindation  = contindation == str.UTF8String;
    }else if ([realID isKindOfClass:[NSNumber class]]) {
        contindation  = contindation == [realID longLongValue];
    }
    
    return [self.dbDatabase updateAllRowsInTable:tableName onProperties:[obj.class AllProperties] withObject:obj];
}

#pragma mark delete object
- (BOOL)deleteObjectFromTable:(NSString *)tableName bandingColumnName:(NSString *)columnName realID:(id)realID{
    
    if (!tableName.length || !columnName.length) {
        LMLog(@"deleteObjectsFromTable error, tableName  or columnName is null");
        return NO;
    }
    
    NSAssert([realID isKindOfClass:[NSString class]] || [realID isKindOfClass:[NSNumber class]] , @"Data error");
    WCDB::Expr contindation(WCDB::Column(columnName.UTF8String));
    if ([realID isKindOfClass:[NSString class]]) {
        NSString *str = realID;
        contindation  = contindation == str.UTF8String;
    }else if ([realID isKindOfClass:[NSNumber class]]) {
        contindation  = contindation == [realID longLongValue];
    }
    return [self.dbDatabase deleteObjectsFromTable:tableName where:contindation];
}

#pragma mark - Private
@end
