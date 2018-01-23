//
//  ResetPasswordViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordView.h"
#import <ReactiveObjC.h>
#import <MBProgressHUD.h>
#import "RegExString.h"
#import "APIServerSdk.h"
#import <JKCategories.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface ResetPasswordViewController ()

@property (nonatomic, strong) ResetPasswordView *resetView;
@property (nonatomic, strong)  MBProgressHUD *hud;
@property (nonatomic, assign) int timeLeft;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *password;
@end

@implementation ResetPasswordViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"忘记密码";
    [super viewDidLoad];
}

- (BOOL)interactivePopEnable{
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (ResetPasswordView *)resetView{
    if (!_resetView) {
        _resetView = [[ResetPasswordView alloc] init];
    }
    return _resetView;
}
#pragma mark - Initialize

- (void)loadView{
    self.view = self.resetView;
}

- (void)configEvent{
    [super configEvent];
    [self bindRAC];
    
    @weakify(self);
    [[self.resetView.buttonSms rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self resendVerficationCode];
    }];
    
    [[self.resetView.buttonModify rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self doResetPass];
    }];
}

#pragma mark - APIServer
- (void)resendVerficationCode
{
    if (![self checkForMobile]) {
        return;
    }
    @weakify(self);
    self.hud = [[HUDHelper sharedInstance] loading:@"正在发送验证码" inView:self.view];
    [APIServerSdk doVerify:self.phone type:@"reset_password" succeed:^(id obj) {
        @strongify(self);
        [self startTimer];
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:@"验证码发送成功" inView:self.view];
    } failed:^(NSString *error) {
        @strongify(self);
        [self.resetView.buttonSms setTitle:@"重新发送" forState:UIControlStateNormal];
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:error inView:self.view];
    }];
}

- (void)doResetPass
{
    if (![self checkForMobile] || ![self checkForSms] || ![self checkForPassword]) {
        return;
    }
    @weakify(self);
    self.hud = [[HUDHelper sharedInstance] loading:@"正在重置" inView:self.view];
    [APIServerSdk doResetPass:self.phone verification:self.code password:self.password succeed:^(id obj) {
        @strongify(self);
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:@"重置成功,请登录" inView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.pushedFromLogin) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                LoginViewController *vc = [[LoginViewController alloc] init];
                UINavigationController *nav =  [[UINavigationController alloc] initWithRootViewController:vc];
                [[AppDelegate sharedAppDelegate] replaceRootViewController:nav animated:YES];
            }
        });
    } failed:^(NSString *error) {
        @strongify(self);
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:error inView:self.view];
    }];
}

#pragma mark - Private methods

- (void)startTimer{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    self.isRunning = YES;
    self.timeLeft = 60;
    _timer = [NSTimer jk_scheduledTimerWithTimeInterval:1 block:^{
        if (self.timeLeft < 1) {
            self.isRunning = NO;
            [self.timer invalidate];
            self.timer = nil;
            [self.resetView.buttonSms setTitle:@"重新发送" forState:UIControlStateNormal];
        }else{
            self.timeLeft -= 1;
            [self.resetView.buttonSms setTitle:[NSString stringWithFormat:@"%dS重发",self.timeLeft] forState:UIControlStateNormal];
        }
    } repeats:YES];
}

- (void)bindRAC{
    RAC(self.resetView.inputPhone,text) = [self limitLengthWithSignal:self.resetView.inputPhone.rac_textSignal textLength:11];

    RAC(self.resetView.inputSms,text)   = [self limitLengthWithSignal:self.resetView.inputSms.rac_textSignal textLength:6];

    RAC(self , phone)                   = [RACSignal merge:@[RACObserve(self.resetView.inputPhone, text),self.resetView.inputPhone.rac_textSignal]];
    
    RAC(self, code)                     = [RACSignal merge:@[RACObserve(self.resetView.inputSms,text),self.resetView.inputSms.rac_textSignal]];
    
    RAC(self, password) = [RACSignal merge:@[RACObserve(self.resetView.inputPass,text),self.resetView.inputPass.rac_textSignal]];
    
    RAC(self.resetView.buttonSms,enabled) = [RACObserve(self, isRunning) map:^id _Nullable(id  _Nullable value) {
        BOOL number = [value boolValue];
        return [NSNumber numberWithBool:!number];
    }];
}

- (BOOL)checkForMobile{
    if (![RegExString checkTelNumber:self.phone]){
        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号" inView:self.view];
        return NO;
    }
    return YES;
}

- (BOOL)checkForSms{
    if (self.code.length != 6){
        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的验证码" inView:self.view];
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
