//
//  MZIMManager.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZIMComm.h"

#define kTIMAccountType @"4034"
#define kTIMAppID 1400008406

@protocol MZIMSendMessage <NSObject>

@end

@class MZIMConversation;
/**
 TIM操作返回block

 @param succeed 获取或者请求是否成功
 @param message 失败时的消息成功时为nil
 */
typedef void(^MZIMResultBlock)(TIMFail fail,TIMSucc succ);

@interface MZIMManager : NSObject

@property (nonatomic, retain) TIMManager *timManager;

/**
 返回MZIMManager单利

 @return sharedInstance单例
 */
+ (MZIMManager *)sharedManager;

/**
 初始化SDK
 */
- (void)initSdk;

/**
 判断用户是否登录

 @return 是否登录
 */
- (BOOL)isUserLogin;

/**
 快速登录 配合App逻辑
 */
- (void)quickLogin:(MZIMCallback)callback;

/**
 IM登录

 @param imID IM ID
 @param userSign 登录密码
 @param callback 成功失败返回
 */
- (void)login:(NSString *)imID userSign:(NSString *)userSign callbcack:(MZIMCallback)callback;

/**
 加载指定类型的会话

 @param filterTypes 过滤的类型
 @return 会话数组
 */
- (NSArray *)loadAllConversations:(NSArray *)filterTypes;


/**
 获取未读消息数

 @param filterTypes 指定类型
 @return 未读消息数量
 */
- (NSInteger)getMessageUnreadTotalNum:(NSArray *)filterTypes;


/**
 加载指定会话

 @param type 会话类型
 @param receiver 用户identifier 或者 群组Id
 @return 会话
 */
- (MZIMConversation *)loadConversation:(TIMConversationType)type andReceiver:(NSString *)receiver;


- (BOOL)deleteConversation:(TIMConversationType)type andReceiver:(NSString *)receiver deleteMessages:(BOOL)deleteMessages;
- (BOOL)deleteConversation:(MZIMConversation*)conversation deleteMessages:(BOOL)deleteMessages;
@end
