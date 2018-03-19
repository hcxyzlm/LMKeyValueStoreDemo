//
//  LMKeyValueDemoTabVCModel.h
//  LMKeyValueStoreDemo
//
//  Created by zhuo on 2018/3/15.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VCModelSuccessListBlock)(NSArray *list, id vcModel);

typedef void (^VCModleFailureBlock)(NSError *error, id vcModel);

@interface LMKeyValueDemoTabVCModel : NSObject

@property (nonatomic, strong) NSArray *titles;

- (void)loadDataWithSuccessCacheBlock:(VCModelSuccessListBlock)success
                              failure:(VCModleFailureBlock)failure;

@end
