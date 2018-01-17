//
//  CommonResponseModel.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "CommonResponseModel.h"

@implementation CommonResponseModel

- (BOOL)isSucceed{
    return self.code == 0;
}

- (BOOL)isFailure{
    return self.code != 0;
}

- (NSString *)getErrorMsg{
    if (self.code == 4001) {
        /// 延迟两秒跳转至登录页面
        [[NSNotificationCenter defaultCenter] postNotificationName:kJKTokenOutofDate object:nil];
        return @"认证信息过期,请重新登录";
    }
    if (!self.msg) {
        return @"未知错误";
    }
    return self.msg;
}

@end
