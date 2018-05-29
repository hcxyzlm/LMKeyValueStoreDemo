//
//  LMKeyValueItem.m
//  lazyaudio
//
//  Created by zhuo on 2018/1/26.
//

#import "LMKeyValueItem.h"
#import <WCDB/WCDB.h>

@implementation LMKeyValueItem

WCDB_IMPLEMENTATION(LMKeyValueItem)

WCDB_SYNTHESIZE_COLUMN(LMKeyValueItem, itemId,"id")
WCDB_SYNTHESIZE_COLUMN(LMKeyValueItem, itemObject, "json")
WCDB_SYNTHESIZE_COLUMN(LMKeyValueItem, createdTime, "createdTime")


- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, value=%@, createTime=%@", _itemId, _itemObject, _createdTime];
}
@end
