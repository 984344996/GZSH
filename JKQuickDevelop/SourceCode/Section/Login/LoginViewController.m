//
//  LoginViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/9.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import <ReactiveObjC.h>

#import "ResetPasswordViewController.h"
#import "ApplicationStep1ViewController.h"
#import "AppDelegate.h"
#import "APIServerSdk.h"
#import "UserInfo.h"
#import <MBProgressHUD.h>
#import "RegExString.h"
#import <MJExtension.h>
#import "MainTabViewController.h"
#import "AppDataFlowHelper.h"
#import "JKNetworkHelper.h"

@interface LoginViewController ()
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) CGFloat topMargin;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView{
    self.view = self.loginView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_topMargin < 1) {
        _topMargin = self.loginView.jk_top;
    }
}


- (void)configView{
    [super configView];
    self.title = @"登录";
    self.loginView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //注册键盘出现NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    if (keyboardHeight == 0) {
        // 解决搜狗输入法三次调用此方法的bug、
        // IOS8.0之后可以安装第三方键盘，如搜狗输入法之类的。
        // 获得的高度都为0.这是因为键盘弹出的方法:- (void)keyBoardWillShow:(NSNotification
        // *)notification需要执行三次,你如果打印一下,你会发现键盘高度为:第一次:0;第二次:216:第三次
        // :282.并不是获取不到高度,而是第三次才获取真正的高度.
        return;
    }
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.loginView setJk_top:self.topMargin - 150];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.loginView setJk_top:self.topMargin];
    }];
}


- (void)configEvent{
    @weakify(self)
    
    [self bindRAC];
    [[self.loginView.btnResetPass rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] init];
        vc.pushedFromLogin = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.loginView.btnApplication rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApplicationStep1ViewController *vc = [[ApplicationStep1ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.loginView.btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if ([self checkForInfoComplete]) {
            [self doLogin];
        }
    }];
}

#pragma mark - Public methods
+(BOOL)checkIfNeedLogin{
    NSString *token = [AppDataFlowHelper getLoginToken];
    if (token) {
        [JKNetworkHelper setToken:token];
        return NO;
    }
    return YES;
}

#pragma mark - Getter setter

- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] init];
    }
    return _loginView;
}

#pragma mark - Private methods

- (void)bindRAC{
    RAC(self.loginView.textPhone,text) = [self limitLengthWithSignal:self.loginView.textPhone.rac_textSignal textLength:11];
    RAC(self , phone) = [RACSignal merge:@[RACObserve(self.loginView.textPhone, text),self.loginView.textPhone.rac_textSignal]];
    RAC(self, password) = [RACSignal merge:@[RACObserve(self.loginView.textPass,text),self.loginView.textPass.rac_textSignal]];
}

- (BOOL)checkForInfoComplete{
    return YES;
}

- (void)doLogin{
    if (![self checkForMobile] || ![self checkForPassword]) {
        return;
    }
    @weakify(self)
    self.hud = [[HUDHelper sharedInstance] loading:@"正在登录" inView:self.view];
    [APIServerSdk doLogin:self.phone password:self.password succeed:^(id obj) {
        @strongify(self);
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:@"登录成功" inView:self.view];
        [self parseLoginData:obj];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MainTabViewController *vc = [[MainTabViewController alloc] init];
            [[AppDelegate sharedAppDelegate] replaceRootViewController:vc animated:YES];
        });
    } failed:^(NSString *error) {
        @strongify(self);
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:error inView:self.view];
    }];
}

- (void)parseLoginData:(id)data{
    CommonResponseModel *mode = data;
    NSDictionary *dic = mode.data;
    NSString *token = dic[@"token"];
    UserInfo *loginUserInfo = [UserInfo mj_objectWithKeyValues:dic[@"userInfo"]];
    
    [AppDataFlowHelper saveLoginToken:token];
    [AppDataFlowHelper saveLoginUserInfo:loginUserInfo];
}

- (BOOL)checkForMobile{
    if (![RegExString checkTelNumber:self.phone]){
        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号" inView:self.view];
        return NO;
    }
    return YES;
}

- (BOOL)checkForPassword{
    if (![RegExString checkPassword:self.password]){
        [[HUDHelper sharedInstance] tipMessage:@"密码最少六个字符" inView:self.view];
        return NO;
    }
    return YES;
}


/// 限制字符长度
- (RACSignal *)limitLengthWithSignal:(RACSignal *)signal textLength:(int)textLength{
    return [signal map:^id(NSString *text) {
        return text.length <= textLength ? text : [text substringToIndex:textLength];
    }];
}


@end
