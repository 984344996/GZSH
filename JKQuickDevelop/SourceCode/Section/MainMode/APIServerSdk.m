//
//  APIServerSdk.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "APIServerSdk.h"
#import "APIRouter.h"
#import <MJExtension.h>
#import "AccomplishModel.h"

static inline NSString* getServerAddr(NSString *relativePath){
    return [NSString stringWithFormat:@"%@%@",APIServer,relativePath];
}

@implementation APIServerSdk

+ (void)doLogin:(NSString *)mobile password:(NSString *)password succeed:(SHRequestSucceed)succeed failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"mobile":mobile,@"password":password};
    [JKNetworkHelper POST:getServerAddr(RLogin) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

// 注册
+ (void)doRegister:(NSString *)mobile
          password:(NSString *)verifyCode
           succeed:(SHRequestSucceed)succeed
            failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"mobile":mobile,@"verifyCode":verifyCode};
    [JKNetworkHelper POST:getServerAddr(RRegister) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

// 注册：register
// 重置密码：reset_password
+ (void)doVerify:(NSString *)mobile
        password:(NSString *)type
         succeed:(SHRequestSucceed)succeed
          failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"mobile":mobile,@"type":type};
    [JKNetworkHelper POST:getServerAddr(RVerify) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

// 完善信息 token
+ (void)doAccomplish:(AccomplishModel *)model
             succeed:(SHRequestSucceed)succeed
              failed:(SHRequestFailed)failed{
    NSDictionary *params = [model mj_keyValues];
    [JKNetworkHelper POST:getServerAddr(RAccomplish) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

// 重置密码
+ (void)doResetPass:(NSString *)mobile
       verification:(NSString *)verification
           password:(NSString *)password
            succeed:(SHRequestSucceed)succeed
             failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"mobile":mobile,
                             @"verification":verification,
                             @"password":password};
    [JKNetworkHelper POST:getServerAddr(RResetPassword) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
