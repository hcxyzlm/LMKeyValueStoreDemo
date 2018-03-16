//
//  LMKeyValueItem+WCTTableCoding.h
//  lazyaudio
//
//  Created by zhuo on 2018/1/26.
//
//

#import "LMKeyValueItem.h"
#import <WCDB/WCDB.h>

@interface LMKeyValueItem (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(itemId)
WCDB_PROPERTY(itemObject)
WCDB_PROPERTY(createdTime)

@end
