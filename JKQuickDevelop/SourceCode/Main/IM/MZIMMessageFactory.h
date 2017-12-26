//
//  MZIMMessageFactory.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZIMComm.h"
#import "MZIMModeExtra.h"
#import <MJExtension.h>

@interface MZIMMessageFactory : NSObject
+ (MZIMMessageFactory *)sharedInstance;


/**
 构造文本消息

 @param text 要发送的文本
 @return 文本消息
 */
- (TIMMessage *)makeTextMessage:(NSString *)text;


/**
 构造语音消息

 @param audioPath 语音文件路径
 @param second 语音长度
 @return 语音消息
 */
- (TIMMessage *)makeAudioMessage:(NSString *)audioPath second:(int)second;


/**
 构造图片消息

 @param imagePath 图片路径
 @return 图片消息
 */
- (TIMMessage *)makeImageMessage:(NSString *)imagePath;


/**
 构造自定义消息

 @param materialInfo 自定义消息内容
 @return 自定义消息
 */
- (TIMMessage *)makeCustomMaterialMessage:(MZIMMaterialInfo *)materialInfo;

@end
