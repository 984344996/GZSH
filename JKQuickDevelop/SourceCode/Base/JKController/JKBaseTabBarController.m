//
//  BaseTabBarController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/20.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKBaseTabBarController.h"
#import <WZLBadgeImport.h>
#import "JKCenterRiseTabBar.h"

@interface JKBaseTabBarController()<JKCenterRiseTabBarDelegate>{
@private
    JKTabBarType tabBarType;
}
@end

@implementation JKBaseTabBarController

- (instancetype)initWithType:(JKTabBarType)type{
    tabBarType = type;
    if (self = [super init]){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configChildVC];
    [self registerRedDotNotification];
    
    if (tabBarType == JKTabBarTypeCenterRise) {
        JKCenterRiseTabBar *tabBar = [[JKCenterRiseTabBar alloc] init];
        tabBar.jk_delegate = self;
        [self setValue:tabBar forKey:@"tabBar"];
    }
}


#pragma mark - Red dot notification

- (void)registerRedDotNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redDotMessageReceived:) name:kJKReddotNotification object:nil];
}

- (void)redDotMessageReceived:(NSNotification *)sender{
    NSDictionary *info = sender.userInfo;
    NSNumber *index    = info[@"index"];
    NSNumber *number   = info[@"number"];
    
    if (number.unsignedIntegerValue > 0) {
        [self showRedDotAtIndex:index.intValue];
    }else{
        [self hideRedDotAtIndex:index.intValue];
    }
}

#pragma mark - Public methods
- (void)configChildVC{
}


-(void)showRedDotAtIndex:(int)index{
    UITabBarItem *item = self.viewControllers[index].tabBarItem;
    item.badgeCenterOffset = CGPointMake(-5, 5);
    [item showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
    [item showBadge];
}

-(void)hideRedDotAtIndex:(int)index{
    UITabBarItem *item = self.viewControllers[index].tabBarItem;
    [item clearBadge];
}

- (void)centerRiseButtonClick:(JKCenterRiseTabBar *)tabBar{
    
}

// 添加单个子控制器
- (void)addChildViewController:(UIViewController *)controller title:(NSString *)title imageNormal:(NSString *)imageNormal imageSelect:(NSString *)imageSelect hasNav:(BOOL)hasNav{
    controller.tabBarItem.title         = title;
    controller.tabBarItem.image         = [[UIImage imageNamed:imageNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:imageSelect] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //如果只需要图片打开
    //controller = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    if (hasNav){
        UINavigationController *nav         = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.navigationItem.title     = title;
        [self addChildViewController:nav];
        return;
    }
    [self addChildViewController:controller];
}

@end
