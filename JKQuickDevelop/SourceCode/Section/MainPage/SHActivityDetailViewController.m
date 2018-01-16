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

@interface SHActivityDetailViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

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
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://hao.360.cn/"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0.0];
    [self.webView loadRequest:req];
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
        [_btnJoin setTitle:@"已经报名" forState:UIControlStateNormal];
        [_btnJoin setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_btnJoin setTitleColor:kDarkGrayColor forState:UIControlStateDisabled];
        [_btnJoin jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
        [_btnJoin jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
        [_btnJoin jk_setBackgroundColor:kDarkGrayColor forState:UIControlStateDisabled];
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
