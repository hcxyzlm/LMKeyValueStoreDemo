//
//  LMKeyValueDemoTabVCModel.m
//  LMKeyValueStoreDemo
//
//  Created by zhuo on 2018/3/15.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import "LMKeyValueDemoTabVCModel.h"
#import <YTKNetwork.h>
#import "LMKeyValueStore.h"
#import "LMRequest.h"
#import "LMKeyValueStore.h"

NSString *const keyDatabaseName = @"LMKeyValueStore.db";

#define kDefaultCacheTime (24 * 60 * 60) // 默认的一天缓存时间
static NSString * const keyStoreTableName = @"KeyValueTable";

@interface LMKeyValueDemoTabVCModel()
@property (nonatomic, strong) LMKeyValueStore *storeHelper; //注释
@end

@implementation LMKeyValueDemoTabVCModel

- (instancetype ) init {
    if (self = [super init]) {
        _storeHelper = [[LMKeyValueStore alloc] initDBWithName:keyDatabaseName];
    }
    
    return self;
}
#pragma mark public

- (void)loadDataWithSuccessCacheBlock:(VCModelSuccessListBlock)success
                              failure:(VCModleFailureBlock)failure {
    if ([self getCache]) {
        if (success) {
            success (self.titles, self);
        }
        return;
    }
    LMRequest *request = [[LMRequest alloc] init];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSMutableArray *titles = [NSMutableArray array];
//        NSLog(@"request json = %@", request.responseObject);
        id json = request.responseJSONObject;
        id result =  [json objectForKey:@"result"];
        for (NSDictionary *dict in [result objectForKey:@"data"]) {
            [titles addObject:[dict objectForKey:@"title"]];
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.storeHelper putCacheString:jsonString withId:[self cacheKey] intoTable:keyStoreTableName];
        self.titles = titles;
        if (success) {
            success (titles, self);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"requset = %@", request.responseJSONObject);
        NSLog(@"error=%@", request.error);
    }];
}

- (id)getCache {
    NSString * jsonstring = [self.storeHelper getCacheStringById:[self cacheKey] fromTable:keyStoreTableName];
    if(!jsonstring) {
        return nil;
    }
    
    if (![self.storeHelper checkCacheValidById:[self cacheKey] fromTable:keyStoreTableName cacheDate:kDefaultCacheTime]) {
        return nil;
    }
    
    NSData *stringData = [jsonstring dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
    
    
    NSMutableArray *titles = [NSMutableArray array];
    id result =  [json objectForKey:@"result"];
    for (NSDictionary *dict in [result objectForKey:@"data"]) {
        [titles addObject:[dict objectForKey:@"title"]];
    }
    self.titles = titles;
    
    return json;
}

- (NSString *)cacheKey {
    
    return NSStringFromClass(self.class);
}

@end
