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
#import "CommonResponseModel.h"
#import "EnterpriseModel.h"

static inline NSString* getServerAddr(NSString *relativePath){
    return [NSString stringWithFormat:@"%@%@",APIServer,relativePath];
}

static inline NSString* integerToString(NSInteger number){
    NSString *str = [NSString stringWithFormat:@"%ld",number];
    return str;
}

@implementation APIServerSdk
/// ====================================================================================


+ (void)commontCallbackDeliver:(id)responseObject succeed:(SHRequestSucceed)succeed failed:(SHRequestFailed)failed{
    [self commontCallbackDeliver:responseObject onlyData:NO succeed:succeed failed:failed];
}

+ (void)commontCallbackDeliver:(id)responseObject onlyData:(BOOL)onlyData succeed:(SHRequestSucceed)succeed failed:(SHRequestFailed)failed{
    CommonResponseModel *response = [CommonResponseModel mj_objectWithKeyValues:responseObject];
    if ([response isSucceed] && succeed) {
        if (onlyData){
            return succeed(response.data);
        }
        succeed(response);
    }else{
        if (failed) {
            failed([response getErrorMsg]);
        }
    }
}

+ (void)netWorkErrorDeliver:(NSString *)defaultError failed:(SHRequestFailed)failed{
    if (failed) {
        if (defaultError) {
            failed(defaultError);
        }else{
            failed(@"网络连接错误");
        }
    }
}

/// ====================================================================================

+ (void)doLogin:(NSString *)mobile password:(NSString *)password succeed:(SHRequestSucceed)succeed failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"mobile":mobile,@"password":password};
    [JKNetworkHelper POST:getServerAddr(RLogin) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

// 注册
+ (void)doRegister:(NSString *)mobile
        verifyCode:(NSString *)verifyCode
           succeed:(SHRequestSucceed)succeed
            failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"mobile":mobile,@"verifyCode":verifyCode};
    [JKNetworkHelper POST:getServerAddr(RRegister) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

// 注册：register
// 重置密码：reset_password
+ (void)doVerify:(NSString *)mobile
            type:(NSString *)type
         succeed:(SHRequestSucceed)succeed
          failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"mobile":mobile,@"type":type};
    [JKNetworkHelper POST:getServerAddr(RVerify) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

// 完善信息 token
+ (void)doAccomplish:(AccomplishModel *)model
             succeed:(SHRequestSucceed)succeed
              failed:(SHRequestFailed)failed{
    NSDictionary *params = [model mj_keyValues];
    [JKNetworkHelper POST:getServerAddr(RAccomplish) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
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
        [self commontCallbackDeliver:responseObject succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

// 上传图片
+ (void)doUploadImage:(UIImage *)image
                  dir:(NSString *)dir
                 name:(NSString *)name
              succeed:(SHRequestSucceed)succeed
               failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"dir":dir};
    
    [JKNetworkHelper uploadSingleImageWithURL:getServerAddr(RUpload) parameters:params image:image name:name fileName:name mimeType:nil progress:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

#pragma mark - 主页

+ (void)doGetBanner:(SHRequestSucceed)succeed  needCache:(BOOL)needCache cacheSucceed:(SHRequestSucceed)cacheSucceed failed:(SHRequestFailed)failed{
    JKHttpRequestCacheResponse cacheCallback = ^(id cacheObject){
        if (cacheObject) {
            [self commontCallbackDeliver:cacheObject onlyData:YES succeed:cacheSucceed failed:failed];
        }
    };
    if (!needCache) {
        cacheCallback = nil;
    }
    
    [JKNetworkHelper GET:getServerAddr(RBanner) parameters:nil cache:cacheCallback success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doGetNews:(NSInteger)page max:(NSInteger)max type:(NSString *)type succeed:(SHRequestSucceed)succeed needCache:(BOOL)needCache cacheSucceed:(SHRequestSucceed)cacheSucceed failed:(SHRequestFailed)failed{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"page":integerToString(page),
                                                                                  @"max":integerToString(max),
                                                                                  }];
    if (type) {
        [params setObject:type forKey:@"type"];
    }
    
    JKHttpRequestCacheResponse cacheCallback = ^(id cacheObject){
        if (cacheObject) {
            [self commontCallbackDeliver:cacheObject onlyData:YES succeed:cacheSucceed failed:failed];
        }
    };
    if (!needCache) {
        cacheCallback = nil;
    }
    
    [JKNetworkHelper GET:getServerAddr(RNews) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doGetDemand:(NSInteger)page max:(NSInteger)max succeed:(SHRequestSucceed)succeed needCache:(BOOL)needCache
       cacheSucceed:(SHRequestSucceed)cacheSucceed failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"page":integerToString(page),
                             @"max":integerToString(max)
                             };
    JKHttpRequestCacheResponse cacheCallback = ^(id cacheObject){
        if (cacheObject) {
            [self commontCallbackDeliver:cacheObject onlyData:NO succeed:cacheSucceed failed:failed];
        }
    };
    if (!needCache) {
        cacheCallback = nil;
    }
    
    [JKNetworkHelper GET:getServerAddr(RDemand) parameters:params cache:cacheCallback success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:NO succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doGetUserDemand:(NSInteger)page succeed:(SHRequestSucceed)succeed failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"page":integerToString(page)};
    [JKNetworkHelper GET:getServerAddr(RUserDemand) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

#pragma mark - Address

// 获取联系人列表
+ (void)doGetUserContact:(SHRequestSucceed)succeed
               needCache:(BOOL)needCache
            cacheSucceed:(SHRequestSucceed)cacheSucceed
                  failed:(SHRequestFailed)failed{
    JKHttpRequestCacheResponse cacheCallback = ^(id cacheObject){
        if (cacheObject) {
            [self commontCallbackDeliver:cacheObject onlyData:YES succeed:cacheSucceed failed:failed];
        }
    };
    if (!needCache) {
        cacheCallback = nil;
    }
    
    [JKNetworkHelper GET:getServerAddr(RContact) parameters:nil cache:cacheCallback success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

// 获取企业库

+ (void)doGetUserEnterprise:(SHRequestSucceed)succeed
                  needCache:(BOOL)needCache
               cacheSucceed:(SHRequestSucceed)cacheSucceed
                     failed:(SHRequestFailed)failed{
    JKHttpRequestCacheResponse cacheCallback = ^(id cacheObject){
        if (cacheObject) {
            [self commontCallbackDeliver:cacheObject onlyData:YES succeed:cacheSucceed failed:failed];
        }
    };
    if (!needCache) {
        cacheCallback = nil;
    }
    
    [JKNetworkHelper GET:getServerAddr(REnterprise) parameters:nil cache:cacheCallback success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
    
}

#pragma mark - 商会圈

+ (void)doGetMoment:(NSString *)userId
               page:(NSInteger)page
            succeed:(SHRequestSucceed)succeed
          needCache:(BOOL)needCache
       cacheSucceed:(SHRequestSucceed)cacheSucceed
             failed:(SHRequestFailed)failed{
    JKHttpRequestCacheResponse cacheCallback = ^(id cacheObject){
        if (cacheObject) {
            [self commontCallbackDeliver:cacheObject onlyData:NO succeed:cacheSucceed failed:failed];
        }
    };
    if (!needCache) {
        cacheCallback = nil;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    [params setObject:integerToString(page) forKey:@"page"];
    
    [JKNetworkHelper GET:getServerAddr(RCircle) parameters:params cache:cacheCallback success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:NO succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doSendMoment:(NSString *)type
                text:(NSString *)text
                imgs:(NSMutableArray *)imgs
             succeed:(SHRequestSucceed)succeed
              failed:(SHRequestFailed)failed{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:type forKey:@"type"];
    [params setObject:text forKey:@"text"];
    
    if (imgs.count != 0) {
        [params setObject:imgs forKey:@"imgs"];
    }
    
    [JKNetworkHelper POST:getServerAddr(RCirclePost) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doPraiseMoment:(NSString *)dynamicId
               succeed:(SHRequestSucceed)succeed
                failed:(SHRequestFailed)failed{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:dynamicId forKey:@"dynamicId"];
    
    [JKNetworkHelper POST:getServerAddr(RCirclePraise) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doComment:(NSString *)dynamicId
          content:(NSString *)content
           userId:(NSString *)userId
          succeed:(SHRequestSucceed)succeed
           failed:(SHRequestFailed)failed{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:dynamicId forKey:@"dynamicId"];
    [params setObject:content forKey:@"content"];
    if (userId){
        [params setObject:userId forKey:@"userId"];
    }
    [JKNetworkHelper POST:getServerAddr(RCircleComment) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doGetMomentDetail:(NSString *)dynamicId
                  succeed:(SHRequestSucceed)succeed
                   failed:(SHRequestFailed)failed{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:dynamicId forKey:@"dynamicId"];
    
    [JKNetworkHelper GET:getServerAddr(RCircleDetail) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}


+ (void)doGetMomentNotice:(SHRequestSucceed)succeed
                   failed:(SHRequestFailed)failed{
    [JKNetworkHelper GET:getServerAddr(RCircleNotice) parameters:nil cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}


#pragma mark - 商会活动

+ (void)doGetActivityMeeting:(NSUInteger)page
                        type:(NSString *)type
                     succeed:(SHRequestSucceed)succeed
                   needCache:(BOOL)needCache
                cacheSucceed:(SHRequestSucceed)cacheSucceed
                      failed:(SHRequestFailed)failed{
    JKHttpRequestCacheResponse cacheCallback = ^(id cacheObject){
        if (cacheObject) {
            [self commontCallbackDeliver:cacheObject onlyData:NO succeed:cacheSucceed failed:failed];
        }
    };
    if (!needCache) {
        cacheCallback = nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":integerToString(page)}];
    if (type) {
        [params setObject:type forKey:@"type"];
    }
    
    [JKNetworkHelper GET:getServerAddr(RMeeting) parameters:nil cache:cacheCallback success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:NO succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
    
}

+ (void)doJoinActivityMeeting:(NSString *)meetingId
                      succeed:(SHRequestSucceed)succeed
                       failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"meetingId":meetingId};
    [JKNetworkHelper POST:getServerAddr(RMeetingJoin) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doFeedback:(NSString *)feedBackStr
           succeed:(SHRequestSucceed)succeed
            failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"content":feedBackStr};
    [JKNetworkHelper POST:getServerAddr(RFeedback) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doGetSysInfo:(SHRequestSucceed)succeed
              failed:(SHRequestFailed)failed{
    [JKNetworkHelper GET:getServerAddr(RSysInfo) parameters:nil cache:^(id  _Nonnull cacheObject) {
        [self commontCallbackDeliver:cacheObject onlyData:YES succeed:succeed failed:failed];
    } success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}


#pragma mark - 个人中心

+ (void)doGetUserInfo:(NSString *)userId
            needCache:(BOOL)needCache
         cacheSucceed:(SHRequestSucceed)cacheSucceed
              succeed:(SHRequestSucceed)succeed
               failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"userId":userId};
    JKHttpRequestCacheResponse cacheCallback = ^(id cacheObject){
        if (cacheObject) {
            [self commontCallbackDeliver:cacheObject onlyData:YES succeed:cacheSucceed failed:failed];
        }
    };
    if (!needCache) {
        cacheCallback = nil;
    }
    [JKNetworkHelper GET:getServerAddr(RUserInfo) parameters:params cache:cacheCallback success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doEditEnterpriseInfo:(EnterpriseModel *)model
                     succeed:(SHRequestSucceed)succeed
                      failed:(SHRequestFailed)failed{
    
    NSMutableDictionary *params = [model mj_keyValues];
    [JKNetworkHelper POST:getServerAddr(REditEnterprise) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doGetEnterpriseInfo:(SHRequestSucceed)succeed
                     failed:(SHRequestFailed)failed{
    [JKNetworkHelper GET:getServerAddr(REnterprise) parameters:nil cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doDemandUpdate:(DemandInfo *)model succeed:(SHRequestSucceed)succeed failed:(SHRequestFailed)failed{
    NSMutableDictionary *params = [model mj_keyValues];
    [JKNetworkHelper POST:getServerAddr(REditDemandUpdate) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doDemandPublish:(DemandInfo *)model succeed:(SHRequestSucceed)succeed failed:(SHRequestFailed)failed{
    NSMutableDictionary *params = [model mj_keyValues];
    [JKNetworkHelper POST:getServerAddr(REditDemand) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:YES succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doLoadOwnDemands:(NSInteger )page
                 succeed:(SHRequestSucceed)succeed
                  failed:(SHRequestFailed)failed{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page":integerToString(page)}];
    [JKNetworkHelper GET:getServerAddr(ROwnDemands) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:NO succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

+ (void)doLoadOtherDemands:(NSString *)userId
                      page:(NSInteger)page
                   succeed:(SHRequestSucceed)succeed
                    failed:(SHRequestFailed)failed{
    NSDictionary *params = @{@"page":integerToString(page),@"userId":userId};
    [JKNetworkHelper GET:getServerAddr(RUserDemand) parameters:params cache:nil success:^(id  _Nonnull responseObject) {
        [self commontCallbackDeliver:responseObject onlyData:NO succeed:succeed failed:failed];
    } failure:^(NSError * _Nonnull error) {
        [self netWorkErrorDeliver:nil failed:failed];
    }];
}

@end
