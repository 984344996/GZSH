//
//  SHWebViewViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/20.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHWebViewViewController.h"
#import <NJKWebViewProgressView.h>
#import <NJKWebViewProgress.h>
#import <JKCategories.h>
#import "HUDHelper.h"

@interface SHWebViewViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progrssProxy;
@end

@implementation SHWebViewViewController

#pragma mark - Life circle

- (instancetype)initWithUrl:(NSString *)loadUrl{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.loadUrl = loadUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configLeftButton];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)configView{
    [super configView];
    [self.view addSubview:self.webView];
    
    CGFloat progressBarHeight                         = 3.f;
    CGRect navigationBarBounds                        = self.navigationController.navigationBar.bounds;
    CGRect barFrame                                   = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    
    _progressView                                     = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.progressBarView.backgroundColor = kMainBlueColor;
    self.progressView.autoresizingMask                = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.webView.delegate = self.progrssProxy;
}

- (void)configLeftButton{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;

    UIButton *backButton                  = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"Bars_Arrow_Right"] forState:UIControlStateNormal];
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:kCommonLargeTextFont];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBack             = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    UIBarButtonItem *itemFixSpace         = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    UIBarButtonItem *itemPre              = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goPre)];
    self.navigationItem.leftBarButtonItems = @[itemBack,itemFixSpace,itemPre];
}


- (void)configData{
    [super configData];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0.0];
    [self.webView loadRequest:req];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat w = self.view.jk_width;
    CGFloat h = self.view.jk_height;
    
    [self.webView setFrame:CGRectMake(0, 0, w, h)];
}

#pragma mark - Private methods
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goPre{
    if ([self.webView canGoBack]){
        [self.webView goBack];
    }
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

#pragma mark - Delegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [self.progressView setProgress:progress animated:YES];
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[HUDHelper sharedInstance] tipMessage:@"加载出错" inView:self.view];
}

@end
