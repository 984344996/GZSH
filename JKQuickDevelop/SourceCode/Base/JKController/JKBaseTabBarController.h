//
//  BaseTabBarController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/20.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JKTabBarType){
    JKTabBarTypeNormal,
    JKTabBarTypeCenterRise
};

@interface JKBaseTabBarController : UITabBarController

/**
 初始化TabBarController

 @param type 类型
 @return 实例
 */
- (instancetype)initWithType:(JKTabBarType)type;

/**
 配置子控制器 需在子类重写（主要是添加自控制器）
 */
- (void)configChildVC;

/**
 显示小红点
 */
- (void)showRedDotAtIndex:(int)index;

/**
 隐藏小红点
 */
- (void)hideRedDotAtIndex:(int)index;

/**
 添加自控制器
 */
- (void)addChildViewController:(UIViewController *)controller title:(NSString *)title imageNormal:(NSString*)imageNormal imageSelect:(NSString *)imageSelect hasNav:(BOOL)hasNav;
@end
