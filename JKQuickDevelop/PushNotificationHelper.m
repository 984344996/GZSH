//
//  PushNotificationHelper.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/3/31.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "PushNotificationHelper.h"
#import "PushActionHelper.h"
#import "AppDelegate.h"

#define UNCategoryNewMessageIdentifier @"UNCategoryNewMessageIdentifier"
@implementation PushNotificationHelper

+ (PushNotificationHelper *)sharedHelper{
    static PushNotificationHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PushNotificationHelper alloc] init];
    });
    
    return instance;
}

#pragma mark - Public methods
- (void)registerNotification{
    if (IOS10_OR_LATER) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                [self registerCategories];
                DLog(@"注册推送成功");
            }else{
                //用户点击不允许
                DLog(@"注册推送失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        // 之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            DLog(@"Registed setting:%@",settings);
        }];
    }else if (IOS8_OR_LATER){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [self getUIUserNotificationSettings];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
#pragma clang diagnostic pop
    }
    //注册远端消息通知获取Device token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - Private methods
- (void)registerCategories{
    [self registerCategoryNewMessage];
}

#pragma mark - IOS8 - 10
- (UIUserNotificationSettings *)getUIUserNotificationSettings{
    UIMutableUserNotificationCategory *categoryNewMessage = [self getUIUserNotificationCategoryNewMessage];
    NSSet *categories = [NSSet setWithObjects:categoryNewMessage, nil];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                            UIUserNotificationTypeAlert
                                            | UIUserNotificationTypeBadge
                                            | UIUserNotificationTypeSound categories:categories];
    return settings;
}

- (UIMutableUserNotificationCategory *)getUIUserNotificationCategoryNewMessage{
    
    UIMutableUserNotificationAction * joinAction = [[UIMutableUserNotificationAction alloc] init];
    joinAction.identifier                        = @"action.join";
    joinAction.title=@"接收邀请";
    joinAction.activationMode                    = UIUserNotificationActivationModeBackground;/// 点击处于是否进入前台
    joinAction.destructive                       = YES;/// YES为红色文字

    UIMutableUserNotificationAction * lookAction = [[UIMutableUserNotificationAction alloc] init];
    lookAction.identifier                        = @"action.look";
    lookAction.title=@"查看邀请";
    lookAction.activationMode                    = UIUserNotificationActivationModeBackground;
    lookAction.authenticationRequired            = NO;
    lookAction.destructive = NO;
    
    UIMutableUserNotificationAction * cancelAction = [[UIMutableUserNotificationAction alloc] init];
    lookAction.identifier                        = @"action.cancel";
    lookAction.title=@"取消";
    lookAction.activationMode                    = UIUserNotificationActivationModeBackground;
    lookAction.authenticationRequired            = YES;
    lookAction.destructive = NO;
    
    UIMutableUserNotificationCategory * category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = UNCategoryNewMessageIdentifier;
    [category setActions:@[joinAction,lookAction,cancelAction] forContext:(UIUserNotificationActionContextDefault)];
    return category;
}

#pragma mark - IOS 10

- (void)registerCategoryNewMessage{
    if (IOS10_OR_LATER) {
        /// UNNotificationActionOptionAuthenticationRequired 需要解锁显示，点击不会进入app
        UNNotificationAction *joinAction             = [UNNotificationAction actionWithIdentifier:@"action.join" title:@"接收邀请" options:UNNotificationActionOptionAuthenticationRequired];
        
        /// UNNotificationActionOptionForeground 黑色文字,点击进入app
        UNNotificationAction *lookAction             = [UNNotificationAction actionWithIdentifier:@"action.look" title:@"查看邀请" options:UNNotificationActionOptionForeground];
        
        /// UNNotificationActionOptionDestructive 红色文字,点击不会进入app
        UNNotificationAction *cancelAction           = [UNNotificationAction actionWithIdentifier:@"action.cancel" title:@"取消" options:UNNotificationActionOptionDestructive];

        UNNotificationCategory *notificationCategory = [UNNotificationCategory categoryWithIdentifier:UNCategoryNewMessageIdentifier actions:@[lookAction, joinAction, cancelAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];

        // 将Category添加到通知中心
        UNUserNotificationCenter *center             = [UNUserNotificationCenter currentNotificationCenter];
        [center setNotificationCategories:[NSSet setWithObject:notificationCategory]];
    }
}

#pragma mark - push notification

#pragma mark - ios10+通知处理
#ifdef __IPHONE_10_0
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    // 收到推送的请求
    UNNotificationRequest *request = notification.request;
    // 收到推送的内容
    UNNotificationContent *content = request.content;
    // 收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    /*
     // 收到推送消息的角标
     NSNumber *badge = content.badge;
     // 收到推送消息body
     NSString *body = content.body;
     // 推送消息的声音
     UNNotificationSound *sound = content.sound;
     // 推送消息的副标题
     NSString *subtitle = content.subtitle;
     // 推送消息的标题
     NSString *title = content.title;
     */
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程通知
        DLog(@"iOS10 收到远程通知");
        [[PushActionHelper sharedHelper] handPushReceived:userInfo isFromRemote:true];
    }else {
        //本地通知
        DLog(@"iOS10 收到本地通知");
        [[PushActionHelper sharedHelper] handPushReceived:userInfo isFromRemote:false];
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

// App通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    /*
     //收到推送消息的角标
     NSNumber *badge = content.badge;
     //收到推送消息body
     NSString *body = content.body;
     //推送消息的声音
     UNNotificationSound *sound = content.sound;
     // 推送消息的副标题
     NSString *subtitle = content.subtitle;
     // 推送消息的标题
     NSString *title = content.title;
     */
    NSString *actionIdentifier = response.actionIdentifier;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程通知点击
        DLog(@"iOS10 收到远程通知点击");
        [[PushActionHelper sharedHelper] handActionTapped:actionIdentifier userInfo:userInfo isFromRemote:true];
    }else {
        //本地通知点击
        DLog(@"iOS10 收到本地通知点击");
        [[PushActionHelper sharedHelper] handActionTapped:actionIdentifier userInfo:userInfo isFromRemote:false];
    }
    completionHandler();
}

#endif


#pragma mark - IOS7-10通知处理
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    DLog(@"IOS7+ 收到远程通知");
    [[PushActionHelper sharedHelper] handPushReceived:userInfo isFromRemote:true];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    DLog(@"IOS4+ 收到本地通知");
    [[PushActionHelper sharedHelper] handPushReceived:notification.userInfo isFromRemote:false];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    DLog(@"IOS8+ 收到远程点击通知");
    [[PushActionHelper sharedHelper] handActionTapped:identifier userInfo:userInfo isFromRemote:true];
    completionHandler();
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{
    DLog(@"IOS9+ 收到远程点击通知");
    [[PushActionHelper sharedHelper] handActionTapped:identifier userInfo:notification.userInfo isFromRemote:true];
    completionHandler();
}

@end
