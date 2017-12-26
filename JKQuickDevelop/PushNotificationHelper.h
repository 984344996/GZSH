//
//  PushNotificationHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/3/31.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
/*
{
    "aps" : {
        "alert" : {
            "title" : "iOS远程消息，我是主标题！-title",
            "subtitle" : "iOS远程消息，我是主标题！-Subtitle",
            "body" : "Dely,why am i so handsome -body",
            "imageUrl" : "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1493108603&di=2ed36cc884527a460de5fd352fafcf54&src=http://pic.58pic.com/58pic/15/12/67/96B58PICd5F_1024.jpg"
        },
        "category" : "UNCategoryNewMessageIdentifier",
        "badge" : "2",
        "mutable-content" : 1,
        "content-available" : 1,
    }
}
*/

@interface PushNotificationHelper : NSObject<UNUserNotificationCenterDelegate>

/**
 推送单例类

 @return 单例对象
 */
+ (PushNotificationHelper *)sharedHelper;

/**
 注册通知事件
 */
- (void)registerNotification;


/// IOS7 - IOS10

/// 收到远程通知 IOS7+
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/// 收到本地通知 IOS4+
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

/// 处理远程通知事件 IOS8+
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler;

/// 处理本地通知事件 IOS9+
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler;

@end
