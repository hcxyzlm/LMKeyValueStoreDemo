//
//  LMLog.h
//  LMKeyValueStoreDemo
//
//  Created by zhuo on 2018/3/14.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#ifndef LMLog_h
#define LMLog_h

#if DEBUG
#define LMLog(...) NSLog(@"LMKeyValueStore: %@", [NSString stringWithFormat:__VA_ARGS__]);
#else
#define LMLog(...)
#endif

#endif /* LMLog_h */
