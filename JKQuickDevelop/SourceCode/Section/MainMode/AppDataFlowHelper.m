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
#import <MagicalRecord/MagicalRecord.h>
#import "DynamicMsg+CoreDataProperties.h"
#import "VipInfo.h"

static NSString *kToken = @"kToken";
static NSString *kLoginUserInfo = @"kLoginUserInfo";
static NSString *kVips = @"kVips";

@implementation AppDataFlowHelper
static UserInfo *currentUserObj;
static NSArray *vipArray;
+ (void)loginOut{
    [JKNetworkCache removeAllHttpCache];
    [self clearLoginToken];
    [self clearLoginUserInfo];
    
    [DynamicMsg MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
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
    NSDictionary *dic      = [userInfo mj_keyValues];
    currentUserObj         = userInfo;
    currentUserObj.vipInfo = [self getVipInfoOfCharmTitle:currentUserObj.chamTitle];
    [KeyValueUtility setValue:dic forKey:kLoginUserInfo];
}

+ (void)clearLoginUserInfo{
    currentUserObj = nil;
    [KeyValueUtility setValue:nil forKey:kLoginUserInfo];
}

+ (UserInfo *)getLoginUserInfo{
    if (currentUserObj) {
        return currentUserObj;
    }
    NSDictionary *dic  = [KeyValueUtility getValueForKey:kLoginUserInfo];
    UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:dic];
    return userInfo;
}

+ (void)saveVipList:(id)vips{
    NSMutableArray *array = [VipInfo mj_objectArrayWithKeyValuesArray:vips];
    vipArray = array;
    [KeyValueUtility setValue:vips forKey:kVips];
    
    if (!currentUserObj) {
        currentUserObj.vipInfo = [self getVipInfoOfCharmTitle:currentUserObj.chamTitle];
    }
}

+ (NSArray *)getVipList{
    if (vipArray) {
        return vipArray;
    }
    id vips  = [KeyValueUtility getValueForKey:kVips];
    if (vips == NULL) {
        return vips;
    }
    NSArray *viplist = [VipInfo mj_objectArrayWithKeyValuesArray:vips];
    vipArray = viplist;
    return viplist;
}

+ (VipInfo *)getVipInfoOfCharmTitle:(NSString *)title{
    NSArray *list = [self getVipList];
    if (!list) {
        return NULL;
    }
    VipInfo __block *vipInfo = NULL;
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VipInfo *info = (VipInfo *)obj;
        if ([info.Id isEqualToString:title]) {
            vipInfo = info;
            *stop = YES;
        }
    }];
    return vipInfo;
}
@end
