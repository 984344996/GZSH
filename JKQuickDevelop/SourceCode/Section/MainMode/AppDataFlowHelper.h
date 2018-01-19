//
//  AppDataFlowHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/19.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface AppDataFlowHelper : NSObject

+ (void)loginOut;

+ (void)saveLoginToken:(NSString *)token;
+ (void)clearLoginToken;
+ (NSString *)getLoginToken;

+ (void)saveLoginUserInfo:(UserInfo *)userInfo;
+ (void)clearLoginUserInfo;
+ (UserInfo *)getLoginUserInfo;


@end
