//
//  MainTabViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/15.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "MainTabViewController.h"
#import "SHMainPageViewController.h"
#import "SHCircleViewController.h"
#import "SHAddressViewController.h"
#import "SHActivityViewController.h"
#import "SHMemberViewController.h"

@interface MainTabViewController()
@end

@implementation MainTabViewController

- (void)configChildVC{
    SHMainPageViewController *mainPageVC = [[SHMainPageViewController alloc] init];
    [self addChildViewController:mainPageVC title:@"主页" imageNormal:@"Home_Icon_House_dark" imageSelect:@"Home_Icon_House_Bright" hasNav:YES];
    
    SHCircleViewController *circleVC = [[SHCircleViewController alloc] init];
    [self addChildViewController:circleVC title:@"商会圈" imageNormal:@"Home_Icon_AddressBook_Dark" imageSelect:@"Home_Icon_AddressBook_Bright" hasNav:YES];
    
    SHAddressViewController *addressVC = [[SHAddressViewController alloc] init];
    [self addChildViewController:addressVC title:@"通讯录" imageNormal:@"Home_Icon_AddressBook_Dark" imageSelect:@"Home_Icon_AddressBook_Bright" hasNav:YES];
    
    SHActivityViewController *activityVC = [[SHActivityViewController alloc] init];
    [self addChildViewController:activityVC title:@"会议活动" imageNormal:@"Home_Icon_Activity_Dark" imageSelect:@"Home_Icon_Activity_Bright" hasNav:YES];
    
    SHMemberViewController *memberVC = [[SHMemberViewController alloc] init];
    [self addChildViewController:memberVC title:@"个人中心" imageNormal:@"Home_Icon_Vip_Dark" imageSelect:@"Home_Icon_Vip_Bright" hasNav:YES];
}

@end
