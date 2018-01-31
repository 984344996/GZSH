//
//  JKBaseViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKBaseViewController.h"
#import "UIImage+JKResize.h"
#import <AFNetworking.h>
#import "AppDataFlowHelper.h"
#import <LEEAlert.h>

@interface JKBaseViewController ()<UIGestureRecognizerDelegate>
/// Nav分隔线
@property (nonatomic , weak , readonly) UIImageView * navSystemLine;
/// TabBar栏分隔线
@property (nonatomic , weak , readonly) UIImageView * tabSystemLine;
@end

@implementation JKPageLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1;
    }
    return self;
}

- (void)showLoadingViewWithType:(LoadingViewType)loadingType andImageArray:(NSArray *)imageArray andPromptText:(NSString *)promptText{
    self.hidden = NO;
    self.alpha = 1;
    switch (loadingType) {
        case LoadingViewTypeHUD:
            self.alpha = 0;
            self.hud =  [[HUDHelper sharedInstance] loading:promptText inView:self.superview];
            break;
        case LoadingViewTypeImages:
            if (!imageArray.count) {
                return;
            }
            self.loadingImage.frame           = CGRectMake(0, 0, kJKLoadingImageWidth,KJKLoadingImageHeight);
            self.loadingImage.animationImages = imageArray;
            self.loadingImage.center          = CGPointMake(self.jk_width * 0.5,self.jk_height * 0.5);
            [self.loadingImage startAnimating];
            [self addSubview:self.loadingImage];
            break;
        case LoadingViewTypeImageAndPromptText:
            if (!imageArray.count) {
                return;
            }
            self.loadingImage.frame           = CGRectMake(0, 0, kJKLoadingImageWidth,KJKLoadingImageHeight);
            self.loadingImage.animationImages = imageArray;
            self.loadingImage.center          = CGPointMake(self.jk_width * 0.5,self.jk_height * 0.5);
            [self addSubview:self.loadingImage];
            if (!promptText.length) {
                promptText                        = @"加载中...";
            }
            self.promptLabel.text             = promptText;
            self.promptLabel.textAlignment    = NSTextAlignmentCenter;
            [self.promptLabel sizeToFit];
            self.promptLabel.center           = CGPointMake(self.loadingImage.jk_centerX,self.loadingImage.jk_bottom + 10);
            [self addSubview:self.promptLabel];
            [self.loadingImage startAnimating];
            break;
    }
}


/**
 停止加载动画
 */
- (void)stopLoading{
    if (_hud) {
        [[HUDHelper sharedInstance] stopLoading:_hud];
        _hud = nil;
    }
    
    [self.loadingImage stopAnimating];
    [self removeFromSuperview];
}

/**
 懒加载
 @return 文字提示Label
 */
-(UILabel *)promptLabel{
    if (!_promptLabel) {
            _promptLabel               = [[UILabel alloc]init];
            _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.textColor         = kMainTextColor;
        _promptLabel.font              = kCommonMiddleTextFont;
    }
    return _promptLabel;
}


/**
 懒加载

 @return 产生的动画ImageView
 */
- (UIImageView *)loadingImage{
    if (!_loadingImage) {
        _loadingImage                      = [[UIImageView alloc]init];
        _loadingImage.animationRepeatCount = 0;
        _loadingImage.animationDuration    = 1;
    }
    return _loadingImage;
}

@end

@implementation JKBaseViewController


#pragma mark - Proj define

- (void)showNoAccessPermissionDialog{
    [LEEAlert alert]
    .config
    .LeeTitle(@"提示")
    .LeeAction(@"确定", nil)
    .LeeAddContent(^(UILabel *label) {
        label.text = @"会员权限不足或者已过期，请联系商会！";
        label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
        label.textAlignment = NSTextAlignmentCenter;
    })
    .LeeShow();
}

- (void)checkForPermisson:(void(^)())hasPermissionHanlder noPermissionHanlder:(void(^)())noPermissionHanlder{
    UserInfo *userInfo = [AppDataFlowHelper getLoginUserInfo];
    if (userInfo.chamModel.level > 7 || [userInfo.vipState isEqualToString:@"INVALID"]) {
        self.hasAccessPermisson = NO;
        if (noPermissionHanlder) {
            noPermissionHanlder();
        }
    }else{
        self.hasAccessPermisson = YES;
        if (hasPermissionHanlder) {
            hasPermissionHanlder();
        }
    }
}


#pragma mark - LifeCircle
-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self checkForPermisson:nil noPermissionHanlder:nil];
    [self configView];
    [self configLayout];
    [self configEvent];
    [self configData];
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![self showNavigationBarBottomLine]) {
        [self hideNavBottomLine];
    }
    if (![self showTabBarTopLine]) {
        [self hideTabBarTopLine];
    }
    
    [self addIconBackNavigationItem];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = [self interactivePopEnable];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
}


- (void)dealloc{
    [self removeObserver];
}

- (void)addObserver{
    if(self.observeNetStatus){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:kJKNetStatusChangeNotification object:nil];
    }
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJKNetStatusChangeNotification object:nil];
}


- (void)addIconBackNavigationItem{
    if (self.navigationController.childViewControllers.count > 1) {
        [self addUIBarButtonItemImage:@"Bars_Arrow_Right" isLeft:YES target:self action:@selector(popBack)];
    }
}

- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化设置

- (void)configView{}
- (void)configData{}
- (void)configLayout{}
- (void)configEvent{}

- (BOOL)showNavigationBarBottomLine{
    return NO;
}

- (BOOL)showTabBarTopLine{
    return YES;
}

- (BOOL)interactivePopEnable{
    return YES;
}

- (CGFloat)topMargin{
        CGFloat margin = [[UIApplication sharedApplication] statusBarFrame].size.height;
        if (self.navigationController && !self.navigationController.navigationBarHidden) {
            margin += self.navigationController.navigationBar.bounds.size.height;
        }
    return margin;
}

#pragma mark - 网络状态监听
- (void)statusChanged:(NSNotification *)notification{
    NSNumber *status = notification.userInfo[@"status"];
    if (status) {
        switch (status.intValue) {
            case AFNetworkReachabilityStatusNotReachable:
                [self statusToNotReachable];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self statusToReachableWiFi];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self statusToReachableWWAN];
                break;
            default:
                break;
        }
    }
}

- (void)statusToNotReachable{

}

- (void)statusToReachableWWAN{
    
}

- (void)statusToReachableWiFi{

}

#pragma mark - Navigation Bar 添加按钮

- (void)addUIBarButtonItemImage:(NSString *)name size:(CGSize)size isLeft:(BOOL)isLeft target:(id)target action:(SEL)action{
    
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CGSize finalSize = image.size;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        finalSize = size;
    }
    
    image = [image jk_resizedImage:finalSize interpolationQuality:kCGInterpolationHigh];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    isLeft ? (self.navigationItem.leftBarButtonItem = item) : (self.navigationItem.rightBarButtonItem = item);
}

- (void)addUIBarButtonItemImage:(NSString *)name isLeft:(BOOL)isLeft target:(id)target action:(SEL)action{
    [self addUIBarButtonItemImage:name size:CGSizeZero isLeft:isLeft target:target action:action];
}

- (void)addUIBarButtonItemText:(NSString *)title isLeft:(BOOL)isLeft target:(id)target action:(SEL)action{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    isLeft ? (self.navigationItem.leftBarButtonItem = item) : (self.navigationItem.rightBarButtonItem = item);
}

#pragma mark - 页面加载
-(void)showLoadingView:(LoadingViewType)type{
    [self showLoadingView:type andImageArray:self.loadingImageArray andPromptText:self.loadingPrompText];
}

- (void)showLoadingView:(LoadingViewType)type andImageArray:(NSArray *)imageArray andPromptText:(NSString *)pomptText{
    [self.loadingView showLoadingViewWithType:type andImageArray:imageArray andPromptText:pomptText];
}

- (JKPageLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView =[[JKPageLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.jk_width, self.view.jk_height)];
    }
    [self.view addSubview:_loadingView];
    return _loadingView;
}


/**
 隐藏加载View
 */
- (void)hideLoadingView{
    [self.loadingView stopLoading];
}

/**
 懒加载

 @return 加载动画数组
 */
- (NSMutableArray *)loadingImageArray{
    if (!_loadingImageArray) {
        _loadingImageArray = [NSMutableArray array];
        for (int i = 1; i < 4;i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_0%d",i]];
            [_loadingImageArray addObject:image];
        }
    }
    return _loadingImageArray;
}

/**
 懒加载

 @return 加载提示文字
 */
- (NSString *)loadingPrompText{
    return NSLocalizedString(@"JKLoadingPromptTitle", nil);
}

#pragma mark - Navigation Tabbar界面调整

- (UIImageView *)findHairLine:(UIView *)view{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self findHairLine:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
}

- (void)hideNavBottomLine{
    _navSystemLine = [self findHairLine:self.navigationController.navigationBar];
    self.navSystemLine.hidden = YES;
}

- (void)hideTabBarTopLine{
    _tabSystemLine = [self findHairLine:self.tabBarController.tabBar];
    self.tabSystemLine.hidden = YES;
}


@end
