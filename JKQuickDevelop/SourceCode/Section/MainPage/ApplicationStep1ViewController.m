//
//  ApplicationStep1ViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep1ViewController.h"
#import "ApplicationStep2ViewController.h"
#import "ApplicationStep1View.h"
#import "HUDHelper.h"
#import "APIServerSdk.h"
#import "RegExString.h"
#import <JKCategories.h>
#import <ReactiveObjC.h>
#import <MBProgressHUD.h>

@interface ApplicationStep1ViewController ()
@property (nonatomic, strong) ApplicationStep1View *applicationStep1View;

@property (nonatomic, strong)  MBProgressHUD *hud;
@property (nonatomic, assign) int timeLeft;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;

@end

@implementation ApplicationStep1ViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"申请入会（1/3）";
    [super viewDidLoad];
}

- (BOOL)interactivePopEnable{
    return NO;
}

- (ApplicationStep1View *)applicationStep1View{
    if (!_applicationStep1View) {
        _applicationStep1View = [[ApplicationStep1View alloc] init];
    }
    return _applicationStep1View;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Initialize

- (void)loadView{
    self.view = self.applicationStep1View;
}

- (void)configEvent{
    [super configEvent];
    [self bindRAC];
    @weakify(self)
    
    [[self.applicationStep1View.buttonSms rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self resendVerficationCode];
    }];
    
    [[self.applicationStep1View.buttonNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self doRegister];
    }];
}



#pragma mark - API Server request

- (void)resendVerficationCode
{
    if (![self checkForMobile]) {
        return;
    }
    @weakify(self);
    self.hud = [[HUDHelper sharedInstance] loading:@"正在发送验证码" inView:self.view];
    [APIServerSdk doVerify:self.phone type:@"register" succeed:^(id obj) {
        @strongify(self);
        [self startTimer];
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:@"验证码发送成功" inView:self.view];
    } failed:^(NSString *error) {
        @strongify(self);
        [self.applicationStep1View.buttonSms setTitle:@"重新发送" forState:UIControlStateNormal];
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:error inView:self.view];
    }];
}

- (void)doRegister
{
    if (![self checkForMobile] || ![self checkForSms]) {
        return;
    }
    @weakify(self);
    self.hud = [[HUDHelper sharedInstance] loading:@"正在注册" inView:self.view];
    [APIServerSdk doRegister:self.phone verifyCode:self.code succeed:^(id obj) {
        @strongify(self);
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:@"注册成功" inView:self.view];
        
    } failed:^(NSString *error) {
        @strongify(self);
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:error inView:self.view];
    }];
}

- (void)toStep2Controller:(NSString *)token{
    ApplicationStep2ViewController *vc = [[ApplicationStep2ViewController alloc] init];
    vc.token = token;
    [self.navigationController pushViewController:vc animated:YES];
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
            [self.applicationStep1View.buttonSms setTitle:@"重新发送" forState:UIControlStateNormal];
        }else{
            self.timeLeft -= 1;
            [self.applicationStep1View.buttonSms setTitle:[NSString stringWithFormat:@"%dS重发",self.timeLeft] forState:UIControlStateNormal];
        }
    } repeats:YES];
}

- (void)bindRAC{
    RAC(self.applicationStep1View.inputPhone,text) = [self limitLengthWithSignal:self.applicationStep1View.inputPhone.rac_textSignal textLength:11];
    
    RAC(self.applicationStep1View.inputSms,text) = [self limitLengthWithSignal:self.applicationStep1View.inputSms.rac_textSignal textLength:6];
    
    RAC(self , phone) = [RACSignal merge:@[RACObserve(self.applicationStep1View.inputPhone, text),self.applicationStep1View.inputPhone.rac_textSignal]];
    RAC(self, code) = [RACSignal merge:@[RACObserve(self.applicationStep1View.inputSms,text),self.applicationStep1View.inputSms.rac_textSignal]];
    
    RAC(self.applicationStep1View.buttonSms,enabled) = [RACObserve(self, isRunning) map:^id _Nullable(id  _Nullable value) {
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

/// 限制字符长度
- (RACSignal *)limitLengthWithSignal:(RACSignal *)signal textLength:(int)textLength{
    return [signal map:^id(NSString *text) {
        return text.length <= textLength ? text : [text substringToIndex:textLength];
    }];
}

@end
