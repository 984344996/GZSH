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

@interface LoginViewController ()
@property (nonatomic, strong) LoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView{
    self.view = self.loginView;
}


- (void)configView{
    [super configView];
    self.title = @"登录";
    self.loginView.backgroundColor = [UIColor whiteColor];
}

- (void)configEvent{
    @weakify(self)
    [[self.loginView.btnResetPass rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.loginView.btnApplication rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApplicationStep1ViewController *vc = [[ApplicationStep1ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.loginView.btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[AppDelegate sharedAppDelegate] configMainUI];
    }];
}

#pragma mark - Public methods
+(BOOL)checkIfNeedLogin{
    return YES;
}

#pragma mark - Getter setter

- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] init];
    }
    return _loginView;
}



@end
