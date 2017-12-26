//
//  MZIMMessage.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZIMComm.h"
#import "MZIMModeExtra.h"

@interface MZIMMessage : NSObject
@property (nonatomic, strong) TIMMessage *timMessage;
@property (nonatomic, assign) MZIMMessageType messageType;

///用户信息
@property (nonatomic, strong) IMUserInfo *userInfo;
///文本消息属性
@property (nonatomic, copy) NSString *text;
///图片消息属性
@property (nonatomic, copy) NSString *imageLocalPath;
@property (nonatomic, copy) NSString *imageThumbnailUrl;
@property (nonatomic, copy) NSString *imageLargeUrl;
@property (nonatomic, copy) NSString *imageOriginalUrl;
@property (nonatomic, assign) CGSize imageOriginalSize;
///语音消息属性
@property (nonatomic, copy) NSString *audioLocalPath;
@property (nonatomic, copy) NSString *audioRecordPath;
@property (nonatomic, assign) NSInteger audioSecond;
@property (nonatomic, strong) TIMSoundElem  *audioElem;
///视频消息属性（暂时不支持）
///自定义消息
@property (nonatomic, strong) MZIMMaterialInfo *matericalInfo;

/**
 根据腾讯消息初始化
 
 @param message 腾讯消息Message
 @return 初始化后的实例 可能为nil
 */
- (instancetype)initWithTIMMessage:(TIMMessage*) message;

/**
 消息是否来自自己
 
 @return 消息是否来自自己
 */
- (BOOL)isMessageFromSelf;

/**
 在最近列表展示的消息
 
 @return 字符串消息
 */
- (NSString*)messageShowInConversationList;

@end
