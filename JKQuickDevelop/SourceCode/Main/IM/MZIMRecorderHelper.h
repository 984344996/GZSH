//
//  MZIMRecorderHelper.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/29.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol  MZIMRecorderHelperDelegate<NSObject>

/**
 录音取消
 */
- (void)recordDidCancled;


/**
 录音失败

 @param msg 失败原因
 */
- (void)recordDidFailed:(NSString *)msg;


/**
 录音成功

 @param path 录音文件存储路径
 @param duration 录音文件时长
 */
- (void)recordDidSuccess:(NSString *)path duration:(NSInteger)duration;


/**
 录音音量变化

 @param power 音量大小
 */
- (void)recordDidPowerChanged:(NSInteger)power;
@end
@interface MZIMRecorderHelper : NSObject


@property (nonatomic, weak)id<MZIMRecorderHelperDelegate>delegate;


/**
 录音帮助类单例

 @return 录音帮助类单例
 */
+ (instancetype)sharedInstance;


/**
 准备录音

 @param path 录音文件待存储路径
 @param delegate 录音代理
 */
- (void)prepareAndRecordWithPath:(NSString *)path delegate:(id<MZIMRecorderHelperDelegate>) delegate;


/**
 停止录音
 */
- (void)stopRecord;


/**
 取消录音
 */
- (void)cancelRecord;
@end
