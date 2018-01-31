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
#import "JKNetworkHelper.h"
#import "JKNetworkCache.h"

static NSString *kToken = @"kToken";
static NSString *kLoginUserInfo = @"kLoginUserInfo";

@implementation AppDataFlowHelper
static UserInfo *currentUserObj;

+ (void)loginOut{
    [JKNetworkCache removeAllHttpCache];
    [self clearLoginToken];
    [self clearLoginUserInfo];
}

#pragma mark - Token

+ (void)saveLoginToken:(NSString *)token{
    [JKNetworkHelper setToken:token];
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
    CharmTitleModel *model = [[CharmTitleModel alloc] initWithChamTitle:userInfo.chamTitle];
    userInfo.chamModel     = model;
    NSDictionary *dic      = [userInfo mj_keyValues];
    currentUserObj         = userInfo;
    [KeyValueUtility setValue:dic forKey:kLoginUserInfo];
}

+ (void)clearLoginUserInfo{
    currentUserObj = nil;
    [KeyValueUtility setValue:nil forKey:kLoginUserInfo];
}

+ (UserInfo *)getLoginUserInfo{
    if (currentUserObj) {
        //currentUserObj.chamModel.level = 8;
        return currentUserObj;
    }
    NSDictionary *dic  = [KeyValueUtility getValueForKey:kLoginUserInfo];
    UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:dic];
    //userInfo.chamModel.level = 8;
    return userInfo;
}

@end
