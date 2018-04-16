//
//  ThirdPayHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
#import "PayModel.h"

typedef NS_ENUM(NSInteger,PayType){
    PayTypeWX,
    PayTypeAL
};

typedef NS_ENUM(NSInteger,PayResult){
    PayResultSuccess,
    PayResultFailure,
    PayResultCancel
};

@interface WXParam:NSObject
@property (nonatomic, strong) NSString *partnerid;
@property (nonatomic, strong) NSString *prepayid;
@property (nonatomic, strong) NSString *package;
@property (nonatomic, strong) NSString *noncestr;
@property (nonatomic, assign) UInt32 timestamp;
@property (nonatomic, strong) NSString *sign;
@end

typedef void(^PayResponseCallback)(PayType type,PayResult result,NSString* message);

@interface ThirdPayHelper : NSObject<WXApiDelegate>

///  一次只能调用一个支付对象
+ (ThirdPayHelper *)sharedInstance;
- (void)processAliPayResult:(NSDictionary *)resultDic;

- (void)thirdPay:(NSString *)channel payModel:(PayModel *)payModel callback:(PayResponseCallback)callback;
- (void)aliPay:(NSString *)orderString scheme:(NSString *)scheme callback:(PayResponseCallback)callback;

@end
