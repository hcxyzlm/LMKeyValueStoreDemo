//
//  LMKeyValueItem.h
//  lazyaudio
//
//  Created by zhuo on 2018/1/26.
//

#import <Foundation/Foundation.h>

// 缓存item

@interface LMKeyValueItem : NSObject

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) NSString *itemObject;
@property (strong, nonatomic) NSDate *createdTime;

@end
