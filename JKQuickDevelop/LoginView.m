//
//  LoginView.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "LoginView.h"
#import <JKCategories.h>

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    _loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] firstObject];
        [self addSubview:self.loginView];
        [self.loginView setFrame:self.bounds];
        [self.loginView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self initView];
    }
    return self;
}

- (void)initView{
    self.textPhone.keyboardType = UIKeyboardTypePhonePad;
    self.textPass.keyboardType = UIKeyboardTypeASCIICapable;
    self.textPass.secureTextEntry = YES;
    
    self.btnLogin.layer.cornerRadius = kCommonButtonRadious;
    self.btnLogin.layer.masksToBounds = YES;
    [self.btnLogin jk_setBackgroundColor:kNavBarThemeColor forState:UIControlStateNormal];
    [self.btnLogin jk_setBackgroundColor:kLightGrayColor forState:UIControlStateDisabled];
    [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLogin setTitleColor:kDarkGrayColor forState:UIControlStateDisabled];
}

@end
