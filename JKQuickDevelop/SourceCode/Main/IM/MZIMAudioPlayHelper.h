//
//  MZIMAudioPlayHelper.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/29.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class MZIMMessage;
@class MZIMMessageTableViewCell;

@interface MZIMAudioPlayHelper : NSObject
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, weak) MZIMMessage *message;
@property (nonatomic, weak) MZIMMessageTableViewCell *playCell;

+ (instancetype)sharedInstance;

/**
 语音播放

 @param message 消息对象
 @param cell  展示控件
 */
- (void)playMessageWithCell:(MZIMMessage *)message andCell:(MZIMMessageTableViewCell *)cell;


/**
 判断此消息是否处于播放状态

 @param message 消息对象
 @return 是否正在播放
 */
- (BOOL)isAudioMessagePlaying:(MZIMMessage *)message;


/**
 停止消息播放
 */
- (void)stopPlay;
@end
