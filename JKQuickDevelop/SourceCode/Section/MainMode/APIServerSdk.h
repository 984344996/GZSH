//
//  APIServerSdk.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKNetworkHelper.h"

@class AccomplishModel;

typedef void(^SHRequestFailed)(NSString* error);
typedef void(^SHRequestSucceed)(id obj);

@interface APIServerSdk : NSObject

// 登录
+ (void)doLogin:(NSString *)mobile
       password:(NSString *)password
        succeed:(SHRequestSucceed)succeed
         failed:(SHRequestFailed)failed;

// 注册
+ (void)doRegister:(NSString *)mobile
        verifyCode:(NSString *)verifyCode
           succeed:(SHRequestSucceed)succeed
            failed:(SHRequestFailed)failed;

// 注册：register
// 重置密码：reset_password
+ (void)doVerify:(NSString *)mobile
            type:(NSString *)type
         succeed:(SHRequestSucceed)succeed
          failed:(SHRequestFailed)failed;

// 完善信息 token
+ (void)doAccomplish:(AccomplishModel *)model
             succeed:(SHRequestSucceed)succeed
              failed:(SHRequestFailed)failed;

// 重置密码
+ (void)doResetPass:(NSString *)mobile
       verification:(NSString *)verification
           password:(NSString *)password
            succeed:(SHRequestSucceed)succeed
             failed:(SHRequestFailed)failed;

@end
