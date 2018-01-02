//
//  LoginViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/9.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"

@interface LoginViewController ()
@property (nonatomic, strong) LoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doInit];
}

- (void)loadView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view = self.loginView;
}


- (void)doInit{
    self.title = @"登录";
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
