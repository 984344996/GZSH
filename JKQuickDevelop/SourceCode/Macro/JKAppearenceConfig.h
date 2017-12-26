//
//  JKAppearenceConfig.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#ifndef JKAppearenceConfig_h
#define JKAppearenceConfig_h


#define kAppBakgroundColor          RGBOF(0xF9F7F8)
#define kAppModalBackgroundColor    [kBlackColor colorWithAlphaComponent:0.6]
#define kAppModalDimbackgroundColor [RGB(16, 16, 16) colorWithAlphaComponent:0.3]

// 主色调
// 导航按钮 UITabBar
#define kNavBarThemeColor             RGB(250, 251, 253)
#define kTabBarTintColor              RGB(251, 216, 95)
#define kTabBarBarTintColor           RGB(255, 255, 255)

#define kTableViewCellHeight 50

// 默认的字体颜色
#define kMainTextColor                kBlackColor
#define kDetailTextColor              RGB(145, 145, 145)

// 刷新显示
#define kDownRefreshLoadOver    @"没有更多了"
#define kDownReleaseToRefresh   @"松开即可更新..."
#define kDownDragUpToRefresh    @"上拉即可更新..."
#define kDownRefreshLoading     @"加载中..."

// 常用的字体
#define kCommonLargeTextFont       [UIFont systemFontOfSize:16]
#define kCommonMiddleTextFont      [UIFont systemFontOfSize:14]
#define kCommonSmallTextFont       [UIFont systemFontOfSize:12]

#endif /* JKAppearenceConfig_h */
