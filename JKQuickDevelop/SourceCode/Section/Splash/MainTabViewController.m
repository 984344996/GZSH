//
//  MainTabViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/15.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "MainTabViewController.h"
#import "HomeViewController.h"
#import "AccountViewController.h"
#import "MessageViewController.h"
#import "MyCityViewController.h"

@interface MainTabViewController()
@end

@implementation MainTabViewController

- (void)configChildVC{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addChildViewController:homeVC title:@"闲鱼" imageNormal:@"home_normal" imageSelect:@"home_highlight" hasNav:YES];
    
    MyCityViewController *mycityVC = [[MyCityViewController alloc] init];
    [self addChildViewController:mycityVC title:@"鱼塘" imageNormal:@"mycity_normal" imageSelect:@"mycity_highlight" hasNav:YES];
    
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self addChildViewController:messageVC title:@"消息" imageNormal:@"message_normal" imageSelect:@"message_highlight" hasNav:YES];
    
    AccountViewController *accountVC = [[AccountViewController alloc] init];
    [self addChildViewController:accountVC title:@"我的" imageNormal:@"account_normal" imageSelect:@"account_highlight" hasNav:YES];
}

@end
