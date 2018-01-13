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
#define kNavBarThemeColor             RGB(31, 185, 34)
#define kNavBarTintColor              RGB(255, 255, 255)
#define kTabBarTintColor              RGBOF(0x1FB922)
#define kTabBarBarTintColor           RGB(255, 255, 255)

#define kTableViewCellHeight 50
#define kCommonButtonRadious 4

// 默认的字体颜色
#define kDetailTextColor              RGB(145, 145, 145)
#define kMainTextColor RGB(49,49,49)
#define kSecondTextColor RGB(185,185,187)
#define kMainBlueColor RGB(0,161,254)
#define kMainYellowColor RGB(248,179,63)
#define kMainGreenColor RGB(31, 185, 34)
#define kMainTextFieldBorderColor RGB(151,151,151)
#define kMainBottomLayerColor RGB(245,245,245)
#define kMainFrontLayerColor RGB(245,245,245)
#define kGrayLineColor [RGB(177, 177, 177) colorWithAlphaComponent:0.2]
// 刷新显示
#define kDownRefreshLoadOver    @"没有更多了"
#define kDownReleaseToRefresh   @"松开即可更新..."
#define kDownDragUpToRefresh    @"上拉即可更新..."
#define kDownRefreshLoading     @"加载中..."

// 常用的字体
#define kCommonLargeTextFont       [UIFont systemFontOfSize:16]
#define kCommonMiddleTextFont      [UIFont systemFontOfSize:14]
#define kCommonSmallTextFont       [UIFont systemFontOfSize:12]

#define kMainTextFieldTextFontLarge [UIFont systemFontOfSize:18]
#define kMainTextFieldTextFont16 [UIFont systemFontOfSize:16]
#define kMainTextFieldTextFontBold16 [UIFont boldSystemFontOfSize:16]
#define kMainTextFieldTextFontMiddle [UIFont systemFontOfSize:14]
#define kMainTextFieldTextFontSmall [UIFont systemFontOfSize:12]
#define kMainTextFieldTextFontBold12 [UIFont boldSystemFontOfSize:12]

#define kAvatar_Size 40



#endif /* JKAppearenceConfig_h */
