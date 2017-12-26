//
//  MZIMMessageDispatcher.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/17.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZIMComm.h"

@class MZIMMessage;

@protocol MZIMMessageDispatcherDelegate <NSObject>
- (void)onNewMessage:(MZIMMessage *)message;
@end

@interface MZIMMessageDispatcher : NSObject
@property (nonatomic, strong) NSMutableDictionary *observers;

+ (MZIMMessageDispatcher *)sharedInstance;


/**
 新消息到来调用这个方法

 @param messages 新来的消息
 */
- (void)newMessagesComing:(NSArray *)messages;


/**
 添加消息监测器（每次注册之后最好对应一次移除操作 可增强性能）

 @param type 消息类型
 @param receiver 接收者
 @param delegate 代理
 */
- (void)addConversationObserver:(TIMConversationType)type receiver:(NSString *)receiver delegate:(id<MZIMMessageDispatcherDelegate>)delegate;


/**
 移除消息监测器（每次注册之后最好对应一次移除操作 可增强性能）

 @param type 消息类型
 @param receiver 接受者
 */
- (void)removeConversationObserver:(TIMConversationType)type receiver:(NSString *)receiver;

@end
