//
//  SHActivityDetailViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHActivityDetailViewController.h"
#import <NJKWebViewProgressView.h>
#import <NJKWebViewProgress.h>
#import <JKCategories.h>
#import "HUDHelper.h"
#import "APIServerSdk.h"
#import <ReactiveObjC.h>
#import "MeetingDetail.h"
#import <MJExtension.h>

@interface SHActivityDetailViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) MeetingDetail *detail;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progrssProxy;
@property (nonatomic, strong) UIButton *btnJoin;

@end

@implementation SHActivityDetailViewController

- (void)viewDidLoad {
    self.title = @"会议活动详情";
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)configView{
    [super configView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.btnJoin];
    
    CGFloat progressBarHeight  = 3.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame            = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.progressBarView.backgroundColor = kMainBlueColor;
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.webView.delegate = self.progrssProxy;
}

- (void)configData{
    [super configData];
    [self loadActivityDetail];
}

- (void)configEvent{
    [super configEvent];
    @weakify(self)
    [[self.btnJoin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self joinActivityOrMeeting];
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
    [self.btnJoin setFrame:CGRectMake(0, h - btnH, w, btnH)];
    [self.webView setFrame:CGRectMake(0, 0, w, h - btnH)];
}

- (void)setDetail:(MeetingDetail *)detail{
    if (!detail) {
        return;
    }
    _detail = detail;
    [self reloadUIStatus];
}

// 状态 正在进行 未开始 已结束
- (void)reloadUIStatus{
    if (!self.detail.meeting.allowApply){
        [self.btnJoin setEnabled:NO];
        [self.btnJoin setTitle:@"未开启报名" forState:UIControlStateNormal];
    }
    
    if ([self.detail.meeting.state isEqualToString:@"OVERDUE"]){
        [self.btnJoin setEnabled:NO];
        [self.btnJoin setTitle:@"报名结束" forState:UIControlStateNormal];
    }
    
    if(self.detail.meeting.allowApply && [self.detail.meeting.state isEqualToString:@"AVAILABLE"]){
        [self.btnJoin setEnabled:YES];
        [self.btnJoin setTitle:@"立即报名" forState:UIControlStateNormal];
    }
    
    if (self.detail.alreadyApply) {
        [self.btnJoin setEnabled:NO];
        [self.btnJoin setTitle:@"已经报名" forState:UIControlStateNormal];
    }
    [self loadUrl:self.detail.url];
}

- (void)loadUrl:(NSString *)url{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0.0];
    [self.webView loadRequest:req];
}

#pragma mark - ApiServer

- (void)loadActivityDetail{
    NSString *meetingId = self.meetingId;
    WEAKSELF
    [APIServerSdk doGetActivityMeetingDetail:meetingId succeed:^(id obj) {
        STRONGSELF
        MeetingDetail *detail = [MeetingDetail mj_objectWithKeyValues:obj];
        strongSelf.detail = detail;
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] tipMessage:error inView:strongSelf.view];
    }];
}

- (void)joinActivityOrMeeting{
    WEAKSELF
    NSString *meetingId = self.meetingId;
    [APIServerSdk doJoinActivityMeeting:meetingId succeed:^(id obj) {
        STRONGSELF
        [strongSelf.btnJoin setEnabled:NO];
        [strongSelf.btnJoin setTitle:@"已经参加" forState:UIControlStateNormal];
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] tipMessage:error inView:strongSelf.view];
    }];
}


#pragma mark - Lazy loading

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (NJKWebViewProgress *)progrssProxy{
    if (!_progrssProxy) {
        _progrssProxy = [[NJKWebViewProgress alloc] init];
        _progrssProxy.webViewProxyDelegate = self;
        _progrssProxy.progressDelegate = self;
    }
    return _progrssProxy;
}

- (UIButton *)btnJoin{
    if (!_btnJoin) {
        _btnJoin = [[UIButton alloc] init];
        _btnJoin.titleLabel.font = kMainTextFieldTextFontBold16;
        [_btnJoin setTitle:@"立即报名" forState:UIControlStateNormal];
        [_btnJoin jk_setBackgroundColor:kNavBarThemeColor forState:UIControlStateNormal];
        [_btnJoin jk_setBackgroundColor:RGB(174, 175, 174) forState:UIControlStateDisabled];
        [_btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnJoin setHidden:YES];
    }
    return _btnJoin;
}

#pragma mark - Delegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [self.progressView setProgress:progress animated:YES];
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.btnJoin setHidden:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.btnJoin setHidden:YES];
    [[HUDHelper sharedInstance] tipMessage:@"加载出错" inView:self.view];
}


@end
