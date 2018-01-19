//
//  AppDataFlowHelper.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/19.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "AppDataFlowHelper.h"
#import <MJExtension.h>
#import "KeyValueUtility.h"

static NSString *kToken = @"kToken";
static NSString *kLoginUserInfo = @"kLoginUserInfo";

@implementation AppDataFlowHelper

+ (void)loginOut{
    [self clearLoginToken];
    [self clearLoginUserInfo];
}

#pragma mark - Token

+ (void)saveLoginToken:(NSString *)token{
    [KeyValueUtility setValue:token forKey:kToken];
}

+ (void)clearLoginToken{
    [KeyValueUtility setValue:nil forKey:kToken];
}

+ (NSString *)getLoginToken{
    NSString *token = [KeyValueUtility getValueForKey:kToken];
    return token;
}

#pragma mark - User Info

+ (void)saveLoginUserInfo:(UserInfo *)userInfo{
    NSDictionary *dic = [userInfo mj_keyValues];
    [KeyValueUtility setValue:dic forKey:kLoginUserInfo];
}

+ (void)clearLoginUserInfo{
    [KeyValueUtility setValue:nil forKey:kLoginUserInfo];
}

+ (UserInfo *)getLoginUserInfo{
    NSDictionary *dic = [KeyValueUtility getValueForKey:kLoginUserInfo];
    UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:dic];
    return userInfo;
}

@end
