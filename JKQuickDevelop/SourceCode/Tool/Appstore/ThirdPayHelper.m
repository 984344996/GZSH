//
//  ThirdPayHelper.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ThirdPayHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import <MJExtension.h>

@interface ThirdPayHelper()
@property (nonatomic, copy) PayResponseCallback callback;
@end

@implementation WXParam
@end

@implementation ThirdPayHelper

+ (ThirdPayHelper *)sharedInstance{
    static ThirdPayHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ThirdPayHelper alloc] init];
    });
    return instance;
}

- (void)thirdPay:(NSString *)channel payModel:(PayModel *)payModel callback:(PayResponseCallback)callback{
    self.callback = callback;
    if ([channel isEqualToString:@"wx"]) {
        WXParam *param = [WXParam mj_objectWithKeyValues:payModel.payData];
        PayReq *req       = [[PayReq alloc] init];
        req.partnerId     = param.partnerid;
        req.prepayId      = param.prepayid;
        req.package       = param.package;
        req.nonceStr      = param.noncestr;
        req.timeStamp     = param.timestamp;
        req.sign          = param.sign;
        [WXApi sendReq:req];
    }else{
        [self aliPay:payModel.payData scheme:@"alipaysdk" callback:callback];
    }
}

- (void)aliPay:(NSString *)orderString scheme:(NSString *)scheme callback:(PayResponseCallback)callback{
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
        [self processAliPayResult:resultDic];
    }];
}

- (void)processAliPayResult:(NSDictionary *)resultDic{
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    NSString *responseCode = resultDic[@"resultStatus"];
    if ([responseCode isEqualToString:@"9000"]) {
        if (self.callback) {
            self.callback(PayTypeAL,PayResultSuccess, strMsg);
        }
    }else if([responseCode isEqualToString:@"6001"]){
        strMsg = @"支付取消！";
        if (self.callback) {
            self.callback(PayTypeAL,PayResultSuccess, strMsg);
        }
    }else{
        strMsg = @"支付出错！";
        if (self.callback) {
            self.callback(PayTypeWX,PayResultCancel, strMsg);
        }
    }
}

#pragma mark - WX

- (void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[PayResp class]]){
        /// 支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功！";
                if (self.callback) {
                    self.callback(PayTypeWX,PayResultSuccess, strMsg);
                }
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付取消！";
                if (self.callback) {
                    self.callback(PayTypeWX,PayResultCancel, strMsg);
                }
                break;
            default:
                strMsg = @"支付出错！";
                if (self.callback) {
                    self.callback(PayTypeWX,PayResultCancel, strMsg);
                }
                break;
        }
    }
}

@end
