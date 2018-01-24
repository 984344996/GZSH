//
//  APIServerSdk.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKNetworkHelper.h"
#import "EnterpriseModel.h"

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

// 上传图片
+ (void)doUploadImage:(UIImage *)image
                  dir:(NSString *)dir
                 name:(NSString *)name
              succeed:(SHRequestSucceed)succeed
               failed:(SHRequestFailed)failed;

#pragma mark - 主页

// 获取滚动栏
+ (void)doGetBanner:(SHRequestSucceed)succeed
          needCache:(BOOL)needCache
       cacheSucceed:(SHRequestSucceed)cacheSucceed
             failed:(SHRequestFailed)failed;

// 获取新闻
+ (void)doGetNews:(NSInteger)page
              max:(NSInteger)max
             type:(NSString *)type
          succeed:(SHRequestSucceed)succeed
        needCache:(BOOL)needCache
     cacheSucceed:(SHRequestSucceed)cacheSucceed
           failed:(SHRequestFailed)failed;

// 获取供求信息
+ (void)doGetDemand:(NSInteger)page
                max:(NSInteger)max
            succeed:(SHRequestSucceed)succeed
          needCache:(BOOL)needCache
       cacheSucceed:(SHRequestSucceed)cacheSucceed
             failed:(SHRequestFailed)failed;

// 获取某人的供求信息
+ (void)doGetUserDemand:(NSInteger)page
                succeed:(SHRequestSucceed)succeed
                 failed:(SHRequestFailed)failed;


#pragma mark - Address

// 获取联系人列表
+ (void)doGetUserContact:(SHRequestSucceed)succeed
               needCache:(BOOL)needCache
            cacheSucceed:(SHRequestSucceed)cacheSucceed
                  failed:(SHRequestFailed)failed;

// 获取企业库
+ (void)doGetUserEnterprise:(SHRequestSucceed)succeed
                  needCache:(BOOL)needCache
               cacheSucceed:(SHRequestSucceed)cacheSucceed
                     failed:(SHRequestFailed)failed;

#pragma mark - 会议活动

// 会议活动
+ (void)doGetActivityMeeting:(NSUInteger)page
                        type:(NSString *)type
                     succeed:(SHRequestSucceed)succeed
                   needCache:(BOOL)needCache
                cacheSucceed:(SHRequestSucceed)cacheSucceed
                      failed:(SHRequestFailed)failed;

+ (void)doJoinActivityMeeting:(NSString *)meetingId
                      succeed:(SHRequestSucceed)succeed
                       failed:(SHRequestFailed)failed;

#pragma mark - 商会圈

+ (void)doGetMoment:(NSString *)userId
            succeed:(SHRequestSucceed)succeed
          needCache:(BOOL)needCache
       cacheSucceed:(SHRequestSucceed)cacheSucceed
             failed:(SHRequestFailed)failed;;

+ (void)doSendMoment:(NSString *)type
                text:(NSString *)text
                imgs:(NSArray *)imgs
             succeed:(SHRequestSucceed)succeed
              failed:(SHRequestFailed)failed;

+ (void)doPraiseMoment:(NSString *)dynamicId
               succeed:(SHRequestSucceed)succeed
                failed:(SHRequestFailed)failed;

+ (void)doComment:(NSString *)dynamicId
          content:(NSString *)content
           userId:(NSString *)userId
          succeed:(SHRequestSucceed)succeed
           failed:(SHRequestFailed)failed;

+ (void)doGetMomentDetail:(NSString *)dynamicId
                  succeed:(SHRequestSucceed)succeed
                   failed:(SHRequestFailed)failed;


+ (void)doGetMomentNotice:(SHRequestSucceed)succeed
                   failed:(SHRequestFailed)failed;
#pragma mark - 个人中心

+ (void)doFeedback:(NSString *)feedBackStr
           succeed:(SHRequestSucceed)succeed
            failed:(SHRequestFailed)failed;


+ (void)doGetSysInfo:(SHRequestSucceed)succeed
              failed:(SHRequestFailed)failed;


+ (void)doEditEnterpriseInfo:(EnterpriseModel *)model
                     succeed:(SHRequestSucceed)succeed
                      failed:(SHRequestFailed)failed;

+ (void)doGetEnterpriseInfo:(SHRequestSucceed)succeed
                     failed:(SHRequestFailed)failed;
@end
