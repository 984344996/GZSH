//
//  JKBaseAppDelegate.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKBaseAppDelegate.h"
#import <objc/runtime.h>
#import "PathUtility.h"
#import <AFNetworking.h>
#import <Appirater.h>
#import "PushNotificationHelper.h"
#import "ClusterPrePermissions.h"
#import "JKAPPVersionCheckHelper.h"
#import "StartPageViewController.h"
#import "SplashViewController.h"
#import "LoginViewController.h"
#import "AppDataFlowHelper.h"
#import "APIServerSdk.h"
#import <LEEAlert.h>
#import <JKCategories.h>
#import <MJExtension.h>
#import <MagicalRecord/MagicalRecord.h>
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "ThirdPayHelper.h"

@implementation JKBaseAppDelegate

+ (instancetype)sharedAppDelegate
{
    return (JKBaseAppDelegate *)[UIApplication sharedApplication].delegate;
}


#pragma mark - UIApplicationDelegate lifeCircle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configAppearance];
    // 用StoryBoard不需要自己创建
    _window                 = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    [self configAppRootController];
    [self configAppLaunch];
    
    // 清空通知栏消息
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    return YES;
}

/** APP即将进入后台 */
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

/** APP已经进入后台 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

/** APP即将进入前台 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

/** APP已经进入前台 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /** 强制更新需在返回APP时再次检测 */
#if kJKSupportUpgrade
    if([JKAPPVersionCheckHelper helper].type == JKAppNewVersionTypeForceUpgrade){
        [[JKAPPVersionCheckHelper helper] checkAPPVersion];
    }
#endif
}

/** APP将要终止进程 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MagicalRecord cleanUp];
    [self saveContext];
}

/** 通过其他APP进入 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([WXApi handleOpenURL:url delegate:[ThirdPayHelper sharedInstance]]) {
        return YES;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"Pay Result from handleOpenURL");
            [[ThirdPayHelper sharedInstance] processAliPayResult:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([WXApi handleOpenURL:url delegate:[ThirdPayHelper sharedInstance]]) {
        return YES;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"Pay Result from openURL");
            [[ThirdPayHelper sharedInstance] processAliPayResult:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}


#pragma mark - push
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog("device token = %@",deviceString)
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    DLog(@"注册失败通知 %@",error.description)
}


#pragma mark - IOS7-10通知响应
/// IOS7+
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[PushNotificationHelper sharedHelper] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

/// IOS4+
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [[PushNotificationHelper sharedHelper] application:application didReceiveLocalNotification:notification];
}

/// IOS8+
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    [[PushNotificationHelper sharedHelper] application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

/// IOS9+
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{
    [[PushNotificationHelper sharedHelper] application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:completionHandler];
}

#pragma mark - Core Data stack after ios10


@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"JKQuickDevelop"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data stack before ios10

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// CoreData表结构集合
- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JKQuickDevelop" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// 持久化协调器
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JKQuickDevelop.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES],
                             
                             NSMigratePersistentStoresAutomaticallyOption,
                             
                             [NSNumber numberWithBool:YES],
                             
                             NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

// CoreData上下文
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - UI Config
/**
 配置App中的控件的默认属性
 */
- (void)configAppearance
{
    // UINavigationBar
    
    // 用背景图片做NavigationBar
    /*
     [[UINavigationBar appearance] setBackgroundImage:[UIImage jk_imageWithColor:kNavBarThemeColor]
     forBarPosition:UIBarPositionAny
     barMetrics:UIBarMetricsDefault];
     
     [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
     */
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:kNavBarThemeColor];
    [[UINavigationBar appearance] setTintColor:kNavBarTintColor];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = kWhiteColor;
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:kNavBarTintColor,
                                                           NSShadowAttributeName:shadow,
                                                           NSFontAttributeName:kCommonLargeTextFont
                                                           }];
    
    //UIBarButtonItem
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:kNavBarTintColor,
                                                           NSShadowAttributeName:shadow,
                                                           NSFontAttributeName:kCommonLargeTextFont
                                                           }
                                                forState:UIControlStateNormal];
    //UITabBarItem
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:kDarkGrayColor,
                                                        NSShadowAttributeName:shadow,
                                                        NSFontAttributeName:kCommonSmallTextFont
                                                        }
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:kTabBarTintColor,
                                                        NSShadowAttributeName:shadow,
                                                        NSFontAttributeName:kCommonSmallTextFont
                                                        }
                                             forState:UIControlStateSelected];
    
    //UITabBar
    [[UITabBar appearance] setTintColor:kTabBarTintColor];
    [[UITabBar appearance] setBarTintColor:kTabBarBarTintColor];
    
    //UILabel
    //[[UILabel appearance] setBackgroundColor:kClearColor];
    //[[UILabel appearance] setTextColor:kMainTextColor];
    
    //UIButton
    //[[UIButton appearance] setTitleColor:kMainTextColor forState:UIControlStateNormal];
    
    //UITableViewCell
    [[UITableViewCell appearance] setBackgroundColor:kClearColor];
    [[UITableViewCell appearance] setTintColor:kNavBarThemeColor];
}

- (void)configStartPageUI{}
- (void)configSplashUI{}
- (void)configLoginUI{}
- (void)configMainUI{}
- (void)enterMainPage{}

#pragma mark - App RootViewController Setting
- (void)configAppRootController{
    if([StartPageViewController checkIfNeedStartPage] && kJKUsingStartPage){
        [self configStartPageUI];
    }else if([SplashViewController checkIfNeedSplash] && kJKUsingSplahPage){
        [self configSplashUI];
    }else if([LoginViewController checkIfNeedLogin] && kJKUsingLoginPage){
        [self configLoginUI];
    }else{
        [self configMainUI];
    }
}

#pragma mark - SDK Active

- (void)refreshUserInfo{
    NSString *userId = [AppDataFlowHelper getLoginUserInfo].userId;
    if (!userId) {
        return;
    }
    [APIServerSdk doGetUserInfo:userId needCache:NO cacheSucceed:nil succeed:^(id obj) {
        UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:obj];
        [AppDataFlowHelper saveLoginUserInfo:userInfo];
    } failed:^(NSString *error) {
    }];
}

- (void)refreshVipData{
    [APIServerSdk doGetVip:^(id obj) {
        CommonResponseModel *model = (CommonResponseModel *)obj;
        NSMutableArray *array = [VipInfo mj_objectArrayWithKeyValuesArray:(model.data)];
        if (array.count > 0) {
            [AppDataFlowHelper saveVipList:model.data];
        }
    } failed:^(NSString *error) {
    }];
}

- (void)presentLogin:(NSNotification *)notifycation{
    [LEEAlert alert]
    .config
    .LeeTitle(@"提示")
    .LeeAction(@"确定", ^{
        [AppDataFlowHelper loginOut];
        LoginViewController *vc = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self replaceRootViewController:nav animated:YES];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = @"登录信息已过期，请重新登录！";
        label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
        label.textAlignment = NSTextAlignmentCenter;
    })
    .LeeShow();
}

- (void)configAppLaunch
{
    // 在需要的界面自行打开
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"GZSH"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLogin:) name:kJKTokenOutofDate object:nil];
    [self refreshUserInfo];
    [self refreshVipData];
    
#if kJKSupportNetOberve
    [self registerNetObeserver];
#endif
#if kJKSupportRater
    [self registerRaterNotifier];
#endif
    
#if kJKSupportPush
    [self registerPushService];
#endif
    
#if kJKSupportUpgrade
    [self registerVersionCheck];
#endif
    
#if kSupportWxPay
    [WXApi registerApp:WXAppId];
#endif
    
#if kSupportAliPay
    
#endif
    
}


/**
 注册网络监听
 */
- (void)registerNetObeserver
{
    AFNetworkReachabilityManager* manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kJKNetStatusChangeNotification object:nil userInfo:@{@"status":[NSNumber numberWithInteger:status]}];
    }];
    [manager startMonitoring];
}


/**
 注册评分通知
 */
- (void)registerRaterNotifier{
    [Appirater setAppId:APPID];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
#ifdef DEBUG
    [Appirater setDebug:NO];
#else
    [Appirater setDebug:NO];
#endif
    [Appirater appLaunched:YES];
}


/**
 请求推送权限
 */
- (void)registerPushService{
    [[PushNotificationHelper sharedHelper] registerNotification];
}

/**
 注册版本更新
 */
- (void)registerVersionCheck{
    [[JKAPPVersionCheckHelper helper] checkAPPVersion];
}

#pragma mark - Controller Push Pop Present Dissmiss

- (UINavigationController *)navigationViewController
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)self.window.rootViewController;
    }
    else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *selectVc = [((UITabBarController *)self.window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)selectVc;
        }
    }
    return nil;
}

- (UIViewController *)topViewController
{
    return [self topViewController:self.window.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)controller{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController *)controller;
        return [self topViewController:nav.topViewController];
    }else if([controller isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)controller;
        return [self topViewController:tab.selectedViewController];
    }else if([controller presentedViewController] == nil){
        return controller;
    }else{
        return [self topViewController:controller.presentedViewController];
    }
}

- (void)pushViewController:(UIViewController *)viewController
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController animated:YES];
    }
}

- (UIViewController *)popViewController
{
    return [[self navigationViewController] popViewControllerAnimated:YES];
}
- (NSArray *)popToRootViewController
{
    return [[self navigationViewController] popToRootViewControllerAnimated:YES];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
{
    return [[self navigationViewController] popToViewController:viewController animated:YES];
}

- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion
{
    UIViewController *top = [self topViewController];
    if (vc.navigationController == nil)
    {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [top presentViewController:nav animated:animated completion:completion];
    }
    else
    {
        [top presentViewController:vc animated:animated completion:completion];
    }
}

- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion
{
    if (vc.navigationController != [JKBaseAppDelegate sharedAppDelegate].navigationViewController)
    {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

- (void)replaceRootViewController:(UIViewController *)controller animated:(BOOL)animated{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(animated){
        [UIView transitionWithView:window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            BOOL oldState = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:NO];
            window.rootViewController = controller;
            [UIView setAnimationsEnabled:oldState];
            
        } completion:nil];
    }else{
        window.rootViewController = controller;
    }
}
@end
