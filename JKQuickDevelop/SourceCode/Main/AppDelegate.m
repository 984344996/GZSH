//
//  AppDelegate.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/9.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "AppDelegate.h"
#import "StartPageViewController.h"
#import "SplashViewController.h"
#import "LoginViewController.h"
#import "MainTabViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)configStartPageUI{
    StartPageViewController *spVC = [[StartPageViewController alloc] init];
    [self.window setRootViewController:spVC];
}

- (void)configSplashUI{
    SplashViewController *splashVC = [[SplashViewController alloc] init];
    [self.window setRootViewController:splashVC];
}

- (void)configLoginUI{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.window setRootViewController:nav];
}

-(void)configMainUI{
    MainTabViewController *mainVC = [[MainTabViewController alloc] initWithType:JKTabBarTypeNormal];
    [self.window setRootViewController:mainVC];
}

- (void)enterMainPage{
    UIViewController *enterVC;
    if ([LoginViewController checkIfNeedLogin] && kJKUsingLoginPage) {
        enterVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }else{
        enterVC = [[MainTabViewController alloc] initWithType:JKTabBarTypeNormal];
    }
    [self replaceRootViewController:enterVC animated:YES];
}

@end
