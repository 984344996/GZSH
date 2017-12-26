//
//  JKBaseAppDelegate.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <IQKeyboardManager.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface JKBaseAppDelegate : UIResponder<UIApplicationDelegate,UNUserNotificationCenterDelegate>{
@protected
    UIBackgroundTaskIdentifier _backgroundTaskIdentifier;
}
@property (strong, nonatomic) UIWindow *window;

// After ios10
@property (readonly, strong) NSPersistentContainer *persistentContainer;

// Before ios10
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


/**
 存储Context
 */
- (void)saveContext;


/**
 单例

 @return 单例
 */
+ (instancetype)sharedAppDelegate;


/**
 App根控制器配置
 */
- (void)configAppRootController;

/**
 App启动配置
 */
- (void)configAppLaunch;

/**
 配置滚动视图页
 */
- (void)configStartPageUI;

/**
 配置广告页
 */
- (void)configSplashUI;

/**
 配置登录界面
 */
- (void)configLoginUI;

/**
 配置主界面
 */
- (void)configMainUI;


/**
 启动页或者广告页结束进入主界面
 */
- (void)enterMainPage;

// 代码中尽量改用以下方式去push/pop/present界面
- (UINavigationController *)navigationViewController;

// 最顶层的控制器
- (UIViewController *)topViewController;

// push
- (void)pushViewController:(UIViewController *)viewController;

// pop
- (UIViewController *)popViewController;
- (NSArray *)popToViewController:(UIViewController *)viewController;
- (NSArray *)popToRootViewController;

// present
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion;
- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion;

/**
 替换跟控制器（如果直接设置动画可能会产生奇怪的效果）

 @param controller 待替换的动画
 @param animated 是否执行动画
 */
- (void)replaceRootViewController:(UIViewController *)controller animated:(BOOL)animated;
@end
