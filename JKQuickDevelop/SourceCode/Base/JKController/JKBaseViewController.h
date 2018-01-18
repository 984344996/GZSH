//
//  JKBaseViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDHelper.h"
#import "UIView+JKFrame.h"

typedef NS_ENUM(NSInteger,LoadingViewType){
    LoadingViewTypeHUD, //MBProgress
    LoadingViewTypeImages, //动画数组
    LoadingViewTypeImageAndPromptText //动画数组和提示文字
};

#define kJKLoadingImageWidth 60
#define KJKLoadingImageHeight 60

/**
 页面加载View 如网络加载等
 */
@interface JKPageLoadingView : UIView

// 图片数组
@property (nonatomic, strong) NSArray *imageAnimationArray;
// 加载图片
@property (nonatomic, strong) UIImageView  *loadingImage;
// 加载时文字提示
@property (nonatomic, strong) UILabel *promptLabel;
// MB加载
@property (nonatomic, strong) MBProgressHUD *hud;

// 展示指定类型的加载View
- (void)showLoadingViewWithType:(LoadingViewType)loadingType andImageArray:(NSArray *)imageArray andPromptText:(NSString *)prompptText;

// 停止加载
- (void)stopLoading;
@end


/**
 ViewController基类
 1、网络检测
 2、页面加载动画
 3、添加UIBarButton
 */

@interface JKBaseViewController : UIViewController

@property (nonatomic, assign)BOOL observeNetStatus;
@property (nonatomic, strong)NSMutableArray* loadingImageArray;
@property (nonatomic, strong)NSString *loadingPrompText;
@property (nonatomic, strong)JKPageLoadingView * loadingView;

- (CGFloat)topMargin;

/**
  返回  可从写 自定义逻辑
 */
- (void)popBack;

/**
 显示NavigationBar 下面线
 */
- (BOOL)showNavigationBarBottomLine;

/**
 显示TabBar 上面线
 */
- (BOOL)showTabBarTopLine;

/**
 手势返回
 */
- (BOOL)interactivePopEnable;

/**
 网络不可用
 */
- (void)statusToNotReachable;

/**
 蜂窝网可用
 */
- (void)statusToReachableWWAN;

/**
 WiFi可用
 */
- (void)statusToReachableWiFi;

/**
 加载时View

 @param type 类型
 */
- (void)showLoadingView:(LoadingViewType)type;
- (void)showLoadingView:(LoadingViewType)type andImageArray:(NSArray *)imageArray andPromptText:(NSString *)pomptText;

/**
 隐藏加载View
 */
- (void)hideLoadingView;

/**
 初始化View 在子Controller里面重写
 */
- (void)configView;


/**
 布局View
 */
- (void)configLayout;


/**
 加载设置数据
 */
- (void)configData;


/**
 配置事件
 */
- (void)configEvent;

/**
 添加图片BarButton

 @param name 图片名字
 @param isLeft 是否是左边
 @param target 目标
 @param action SEL
 */
- (void)addUIBarButtonItemImage:(NSString *)name isLeft:(BOOL)isLeft target:(id)target action:(SEL)action;

- (void)addUIBarButtonItemImage:(NSString *)name size:(CGSize)size isLeft:(BOOL)isLeft target:(id)target action:(SEL)action;
/**
 添加图片BarButton
 
 @param title 按钮Title
 @param isLeft 是否是左边
 @param target 目标
 @param action SEL
 */
- (void)addUIBarButtonItemText:(NSString *)title isLeft:(BOOL)isLeft target:(id)target action:(SEL)action;
@end
