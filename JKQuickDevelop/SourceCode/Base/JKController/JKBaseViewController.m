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

@interface JKBaseViewController ()
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

#pragma mark - LifeCircle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self configView];
    [self configLayout];
    [self configEvent];
    [self configData];
    [self addObserver];
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

#pragma mark - 初始化设置
- (void)configView{}
- (void)configData{}
- (void)configLayout{}
- (void)configEvent{}

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

- (void)addUIBarButtonItemImage:(NSString *)name isLeft:(BOOL)isLeft target:(id)target action:(SEL)action{
    CGSize size = CGSizeMake(20, 20);
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image = [image jk_resizedImage:size interpolationQuality:kCGInterpolationHigh];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    isLeft ? (self.navigationItem.leftBarButtonItem = item) : (self.navigationItem.rightBarButtonItem = item);
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

@end
