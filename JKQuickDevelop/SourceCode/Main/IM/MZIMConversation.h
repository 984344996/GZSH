//
//  MZIMConversation.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZIMComm.h"

@class MZIMMessage;
@class MZIMMaterialInfo;

@interface MZIMConversation : NSObject

@property (nonatomic, strong)TIMConversation *timConversation;
@property (nonatomic, strong)MZIMMessage *lastMessage;


- (instancetype) initWithTIMConversation:(TIMConversation *)conversation;
- (instancetype) initWithType:(TIMConversationType )type andReceiver:(NSString *)receiver;
/**
 加载消息

 @param count 加载数量
 @param message 上一条消息 可以为nil
 @param callback 消息返回
 */
- (void)loadMessages:(int)count lastMessage:(MZIMMessage *) message messageListCallback:(MZIMMessageListCallback) callback;

/**
 加载本地消息
 
 @param count 加载数量
 @param message 上一条消息 可以为nil
 @param callback 消息返回
 */

- (void)loadLocalMessages:(int)count lastMessage:(MZIMMessage *) message messageListCallback:(MZIMMessageListCallback) callback;

/**
 加载最近一条消息

 @param callback 返回最近一条消息
 */
- (void)loadLastMessage:(MZIMMessageListCallback) callback;

/**
 加载最近多条消息

 @param count 消息条数
 @return 加载的消息
 */
- (NSArray *)loadLastMessages:(int)count;


/**
 设置会话中所有消息已读
 */
- (void)setAllMessageRead;

#pragma mark - 发送消息
- (void)sendTextMessage:(NSString *)text mzCallback:(MZIMCallback) callback;
- (void)sendAudioMessage:(NSString *)audioPath second:(int)second mzCallback:(MZIMCallback) callback;
- (void)sendImageMessage:(NSString *)imagePath mzCallback:(MZIMCallback) callback;
- (void)sendCustomMessage:(MZIMMaterialInfo *)materialInfo mzCallback:(MZIMCallback) callback;
@end
