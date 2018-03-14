//
//  LMWCDBOperation.m
//  lazyaudio
//
//  Created by zhuo on 2018/1/23.
//

#import "LMWCDBOperation.h"
#import <WCDB/WCDB.h>
#import "LMLog.h"



NSString *const keyDatabaseName = @"LMKeyValueStore.db";

@interface LMWCDBOperation ()

@property (nonatomic, strong) NSString *dbFilePath;
@property (nonatomic, strong, readwrite) WCTDatabase *dbDatabase;

@end

@implementation LMWCDBOperation

#pragma mark - Override

- (void)dealloc {
    
    [self.dbDatabase close];
}

#pragma mark - Getter & Setter

- (NSString *)dbFilePath {
    if (nil == _dbFilePath) {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _dbFilePath = [documentsPath stringByAppendingPathComponent:keyDatabaseName];
        LMLog(@"database file path [%@]", _dbFilePath);
    }
    
    return _dbFilePath;
}

#pragma mark - Public

+ (nonnull instancetype)shareOperation {
    
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}

- (instancetype)init {
    if (self = [super init]) {
        self.dbDatabase = [[WCTDatabase alloc] initWithPath:self.dbFilePath];
        if (!self.dbDatabase) {
            return nil;
        }
#if DEBUG_DATABASE
        [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
            LMLog(@"SQL: %@", sql);
        }];
#endif
        
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
