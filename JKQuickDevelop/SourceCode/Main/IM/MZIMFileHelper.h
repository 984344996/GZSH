//
//  MZIMFileHelper.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/29.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathUtility.h"

@interface MZIMFileHelper : NSObject

/**
 获取图片存储路径
 */
+ (NSString *)getRecommendImagePath;

/**
 获取录音存储路径
 */
+ (NSString *)getRecommendAudioPath;

/**
 获取语音消息下载路径
 */
+ (NSString *)getRecommendAudioStoreMessage:(NSString *)uuid;

/**
 获取视频消息下载路径
 */
+ (NSString *)getRecommendVideoStoreMessage:(NSString *)uuid;

@end
