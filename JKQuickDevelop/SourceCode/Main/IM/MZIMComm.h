//
//  MZIMComm.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#ifndef MZIMComm_h
#define MZIMComm_h

#define kMZIMMessageNotificationLoginSuccess @"kMZIMMessageNotificationLoginSuccess"
#define kMZIMMessageNotificationNewMessage @"kMZIMMessageNotificationNewMessage"
#define kZIMMessageNotificationForceOffline @"kZIMMessageNotificationForceOffline"
#define kMZIMMessageNotificationOnDisconnect @"kMZIMMessageNotificationOnDisconnect"
#define kMZIMMessageNotificationOnConnSucc @"kMZIMMessageNotificationOnConnSucc"
#define kMZIMMessageNotificationConversationReaded @"kMZIMMessageNotificationConversationReaded"
#define kMZIMMessageNotificationConversationDeleted @"kMZIMMessageNotificationConversationDeleted"

#import <ImSDK/ImSDK.h>

/**
 获取消息Callback

 @param isSuccess 获取消息是否成功
 @param message Error msg 成功时为nil
 @param messages 消息数组
 */
typedef void(^MZIMMessageListCallback)(BOOL isSuccess,NSString *message,NSArray *messages);

/**
 获取消息Callback
 
 @param isSuccess 获取消息是否成功
 @param message Error msg 成功时为nil
 */
typedef void(^MZIMCallback)(BOOL isSuccess,NSString *message);

/**
 IM消息类型
 
 - MZIMMessageTypeText: 文本消息
 - MZIMMessageTypeImage: 图片消息
 - MZIMMessageTypeAudio: 语音消息
 - MZIMMessageTypeCustomAudio: 语音素材
 */
typedef NS_ENUM(NSInteger,MZIMMessageType){
    MZIMMessageTypeText,
    MZIMMessageTypeImage,
    MZIMMessageTypeAudio,
};

#endif /* MZIMComm_h */
