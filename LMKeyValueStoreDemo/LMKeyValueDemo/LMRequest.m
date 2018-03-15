//
//  LMRequest.m
//  LMKeyValueStoreDemo
//
//  Created by zhuo on 2018/3/15.
//  Copyright © 2018年 zhuo. All rights reserved.
//

#import "LMRequest.h"

@implementation LMRequest

- (NSString *)requestUrl {
    return @"/toutiao/index";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)baseUrl {
    return @"http://v.juhe.cn";
}

- (id)requestArgument {
    return @{@"key":@"dc8d703be73423485488e56e69e2d98b"};
}

@end
