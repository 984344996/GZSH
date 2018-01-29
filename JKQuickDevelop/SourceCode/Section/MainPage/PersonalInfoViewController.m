//
//  PersonalInfoViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/13.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "MemberCenterTableViewHeaderView.h"
#import "MyCompanyInfoViewController.h"
#import "MySupplyAndDemandViewController.h"
#import "SHCircleViewController.h"
#import <SGPagingView.h>
#import <JKCategories.h>
#import "APIServerSdk.h"
#import "HUDHelper.h"
#import "AppUtils.h"
#import <MJExtension.h>
#import <ReactiveObjC.h>

@interface PersonalInfoViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegate>

@property (nonatomic, strong) MemberCenterTableViewHeaderView *header;
@property (nonatomic, strong) MyCompanyInfoViewController *companyVC;
@property (nonatomic, strong) MySupplyAndDemandViewController *supplyVC;
@property (nonatomic, strong) SHCircleViewController *momentVC;
@property (nonatomic, strong) UIButton *btnMessage;
@property (nonatomic, strong) UIButton *btnPhoneCall;
@property (nonatomic, strong) SGPageTitleView *pageTitle;
@property (nonatomic, strong) SGPageContentView *contentView;
@property (nonatomic, assign) NSUInteger selectedSegmentIndex;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation PersonalInfoViewController

- (instancetype)initWithUserId:(NSString *)userId{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.title = @"个人资料";

    [self.view addSubview:self.header];
    [self.view addSubview:self.pageTitle];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.btnMessage];
    [self.view addSubview:self.btnPhoneCall];
}

- (void)configData{
    [super configData];
    [self loadUserInfo:self.userId];
}


- (BOOL)checkMobile{
    if (!_userInfo) {
        [[HUDHelper sharedInstance] tipMessage:@"未获取到用户信息" inView:self.view];
        return NO;
    }
    return YES;
}

- (void)configEvent{
    [super configEvent];
    
    @weakify(self)
    [[self.btnPhoneCall rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if ([self checkMobile]) {
            [AppUtils makePhoneCallTo:self.userInfo.mobile];
        }
    }];
    
    [[self.btnMessage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if ([self checkMobile]) {
            [AppUtils sendSmsTo:self.userInfo.mobile];
        }
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGFloat w = self.view.jk_width;
    CGFloat h = self.view.jk_height;
    
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += kDeltaForIphoneX;
    }
    [self.btnMessage setFrame:CGRectMake(0, h - btnH, w / 2, btnH)];
    [self.btnPhoneCall setFrame:CGRectMake(w / 2, h - btnH, w / 2, btnH)];
}

#pragma mark - Lazy loading

- (SGPageTitleView *)pageTitle{
    if (!_pageTitle) {
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        [configure setTitleFont:[UIFont systemFontOfSize:15]];
        [configure setTitleColor:[UIColor whiteColor]];
        [configure setTitleSelectedColor:[UIColor whiteColor]];
        [configure setIndicatorColor:RGB(255, 255, 140)];
        [configure setIndicatorBorderColor:[UIColor clearColor]];
        [configure setIndicatorAdditionalWidth:2];
        [configure setIndicatorHeight:3];
        CGRect titleFrame   = CGRectMake(0, 99, JK_SCREEN_WIDTH, 48);
        NSArray *titleNames = [NSArray arrayWithObjects:@"企业信息",@"供求信息",@"商会动态", nil];
        _pageTitle      = [SGPageTitleView pageTitleViewWithFrame:titleFrame delegate:self titleNames:titleNames configure:configure];
        [_pageTitle setBackgroundColor:kNavBarThemeColor];
        [_pageTitle setIsShowBottomSeparator:NO];
    }
    return _pageTitle;
}

- (SGPageContentView *)contentView{
    if (!_contentView) {
        NSArray *childVCs                        = [NSArray arrayWithObjects:self.companyVC,self.supplyVC,self.momentVC, nil];
        _contentView                         = [[SGPageContentView alloc] initWithFrame:[self getContentFrame] parentVC:self childVCs:childVCs];
        _contentView.delegatePageContentView = self;
        [self.view addSubview:self.contentView];
    }
    return _contentView;
}

- (CGRect)getContentFrame{
    CGFloat h = self.view.jk_height;
    CGFloat w = self.view.jk_width;
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += kDeltaForIphoneX;
    }
    CGFloat topMargin = 99 + 48;
    return CGRectMake(0, topMargin , w, h - topMargin - btnH - self.topMargin);
}

- (MemberCenterTableViewHeaderView *)header{
    if (!_header) {
        _header = [[MemberCenterTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, 99)];
    }
    return _header;
}

- (MyCompanyInfoViewController *)companyVC{
    if (!_companyVC) {
        _companyVC = [[MyCompanyInfoViewController alloc] initWithUserId:self.userId isSelf:NO];
    }
    return _companyVC;
}

- (MySupplyAndDemandViewController *)supplyVC{
    if (!_supplyVC) {
        _supplyVC = [[MySupplyAndDemandViewController alloc] initWithUserId:self.userId isSelf:NO];
    }
    return _supplyVC;
}

- (SHCircleViewController *)momentVC{
    if (!_momentVC) {
        _momentVC = [[SHCircleViewController alloc] initWithMainPage:NO userid:self.userId];
        CGFloat btnH = 56;
        if (kDevice_Is_iPhoneX) {
            btnH += kDeltaForIphoneX;
        }
        _momentVC.bottomMargin = btnH;
    }
    return _momentVC;
}


- (UIButton *)btnMessage{
    if (!_btnMessage) {
        _btnMessage                 = [[UIButton alloc] init];
        _btnMessage.titleLabel.font = kMainTextFieldTextFontBold16;
        [_btnMessage setTitle:@"发短信" forState:UIControlStateNormal];
        [_btnMessage setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_btnMessage jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
        [_btnMessage jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
    }
    return _btnMessage;
}

- (UIButton *)btnPhoneCall{
    if (!_btnPhoneCall) {
        _btnPhoneCall                 = [[UIButton alloc] init];
        _btnPhoneCall.titleLabel.font = kMainTextFieldTextFontBold16;
        [_btnPhoneCall setTitle:@"打电话" forState:UIControlStateNormal];
        [_btnPhoneCall setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_btnPhoneCall jk_setBackgroundColor:kMainYellowColor forState:UIControlStateNormal];
        [_btnPhoneCall jk_setBackgroundColor:[kMainYellowColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
    }
    return _btnPhoneCall;
}

#pragma mark - APIServer

- (void)loadUserInfo:(NSString *)userId{
    WEAKSELF
    [APIServerSdk doGetUserInfo:userId needCache:YES cacheSucceed:^(id obj){
        STRONGSELF
        UserInfo *userInfo         = [UserInfo mj_objectWithKeyValues:obj];
        strongSelf.userInfo = userInfo;
        [strongSelf.header setUserInfo:userInfo];
    } succeed:^(id obj) {
        STRONGSELF
        UserInfo *userInfo         = [UserInfo mj_objectWithKeyValues:obj];
        strongSelf.userInfo = userInfo;
        [strongSelf.header setUserInfo:userInfo];
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] tipMessage:@"加载用户信息失败" inView:strongSelf.view];
    }];
}

#pragma mark - Delegate

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex{
    self.selectedSegmentIndex = selectedIndex;
    [self.contentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    if((progress - 1.0) > -0.01 && (progress - 1.0) < 0.01){
        self.selectedSegmentIndex = targetIndex;
    }
    self.selectedSegmentIndex = targetIndex;
    [self.pageTitle setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}


@end
