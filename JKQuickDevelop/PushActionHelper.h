//
//  PushActionHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/3/31.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const NotificationPushReceived;
extern NSString *const NotificationActionTapped;

/**
 推送相关消息类型

 - ActionItemTypePush: 接收到推送
 - ActionItemTypeActionTapped: 推送项点击
 */

typedef NS_ENUM(NSInteger,ActionItemType){
    ActionItemTypePush,
    ActionItemTypeActionTapped
};

@interface PushActionItem : NSObject

- (instancetype)initWithType:(ActionItemType) actionType andIdentifier:(NSString *)actionIdentifier andUserInfo:(NSDictionary *)userInfo andIsFromRemote:(BOOL)isFromRemote;
/**
 推送消息类型
 */
@property (nonatomic, assign) ActionItemType actionType;


/**
 点击Action项
 */
@property (nonatomic, strong) NSString *actionIdentifier;


/**
 推送消息内容
 */
@property (nonatomic, strong) NSDictionary *userInfo;


/**
 是否是远程推送
 */
@property (nonatomic, assign) BOOL isFromRemote;
@end

@interface PushActionHelper : NSObject

/**
 等待处理的Action
 */
@property (nonatomic, strong) PushActionItem *actionWaitToDeal;

/**
 单例类 处理推送点击事件

 @return 单例对象
 */
+ (PushActionHelper *)sharedHelper;


/**
 处理远程事件（当App处于前台或者App刚进入会调用）

 @param actionIdentifier action标识
 @param userInfo 推送信息
 @param isFromRemote 是否来自远程推送
 */
- (void)handActionTapped:(NSString *)actionIdentifier  userInfo:(NSDictionary *)userInfo isFromRemote:(BOOL)isFromRemote;


/**
 接收到通知时响应（当App处于前台或者App刚进入会调用）

 @param userInfo 推送信息
 @param isFromRemote 是否来自远程推送
 */
- (void)handPushReceived:(NSDictionary *)userInfo isFromRemote:(BOOL)isFromRemote;

@end
