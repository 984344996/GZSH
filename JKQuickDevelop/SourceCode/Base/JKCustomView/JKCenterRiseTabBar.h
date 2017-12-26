//
//  JKCenterRiseTabBar.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/22.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKCenterRiseTabBar;
@protocol JKCenterRiseTabBarDelegate <NSObject>

/**
 中间按钮点击事件发生

 @param tabBar JKCenterRiseTabBar
 */
-(void)centerRiseButtonClick:(JKCenterRiseTabBar *)tabBar;

@end

@interface JKCenterRiseTabBar : UITabBar

/**
 JKCenterRiseTabBar代理
 */
@property (nonatomic, weak)id<JKCenterRiseTabBarDelegate> jk_delegate;

@end
