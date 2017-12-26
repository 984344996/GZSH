//
//  MZIMListener.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/17.
//  Copyright © 2016年 infomedia. All rights reserved.
//
#import "MZIMMessageDispatcher.h"
#import "MZIMListener.h"

@implementation MZIMListener

#pragma mark - TIMMessageListener
+ (MZIMListener *)sharedInstance{
    static MZIMListener *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MZIMListener alloc] init];
    });
    
    return instance;
}

/**
 有新消息来回调

 @param msgs 消息数组
 */
-(void)onNewMessage:(NSArray *)msgs{
    [[MZIMMessageDispatcher sharedInstance] newMessagesComing:msgs];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMZIMMessageNotificationNewMessage object:nil];
}

#pragma mark - TIMConnListener
- (void)onConnFailed:(int)code err:(NSString *)err{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMZIMMessageNotificationOnDisconnect object:nil];
}

- (void)onDisconnect:(int)code err:(NSString *)err{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMZIMMessageNotificationOnDisconnect object:nil];
}

- (void)onConnSucc{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMZIMMessageNotificationOnConnSucc object:nil];
}

#pragma mark - TIMUserStatusListener
- (void)onForceOffline{
    [[NSNotificationCenter defaultCenter] postNotificationName:kZIMMessageNotificationForceOffline object:nil];
}

- (void)onReConnFailed:(int)code err:(NSString *)err{
    
}
@end
