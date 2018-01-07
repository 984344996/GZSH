//
//  ResetPasswordView.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/3.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ResetPasswordView.h"
#import <JKCategories.h>

@implementation ResetPasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initConstriant];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.inputPhone];
    [self addSubview:self.inputSms];
    [self addSubview:self.inputPass];
    
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    [self addSubview:self.line3];
    
    [self addSubview:self.buttonSms];
    [self addSubview:self.buttonModify];
}

- (void)initConstriant{
    
}

#pragma mark - Lazy loading

- (UITextField *)inputPhone{
    if (!_inputPhone) {
        _inputPhone = [[UITextField alloc] init];
        _inputPhone.textColor = kMainTextColor;
        _inputPhone.font = kMainTextFieldTextFontLarge;
        _inputPhone.placeholder = @"请输入你的手机号";
        _inputPhone.keyboardType = UIKeyboardTypePhonePad;
    }
    return _inputPhone;
}


- (UITextField *)inputSms{
    if (!_inputSms) {
        _inputSms = [[UITextField alloc] init];
        _inputSms.textColor = kMainTextColor;
        _inputSms.font = kMainTextFieldTextFontLarge;
        _inputSms.placeholder = @"请输入验证码";
        _inputSms.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _inputSms;
}

- (UITextField *)inputPass{
    if (!_inputPass) {
        _inputPass = [[UITextField alloc] init];
        _inputPass.textColor = kMainTextColor;
        _inputPass.font = kMainTextFieldTextFontMiddle;
        _inputPass.placeholder = @"请输入至少6位包含英文数字的新密码";
        _inputPass.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _inputPass;
}

- (UIButton *)buttonSms{
    if (!_buttonSms) {
        _buttonSms = [[UIButton alloc] init];
        _buttonSms.titleLabel.font = kMainTextFieldTextFontMiddle;
        [_buttonSms setTitle:@"获取验证码" forState: UIControlStateNormal];
        [_buttonSms setTitleColor:kMainBlueColor forState:UIControlStateNormal];
        [_buttonSms setTitleColor:[kMainBlueColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
        [_buttonSms setTitleColor:kSecondTextColor forState:UIControlStateDisabled];
    }
    return _buttonSms;
}

- (UIButton *)buttonModify{
    if (!_buttonModify) {
        _buttonModify = [[UIButton alloc] init];
        _buttonModify.titleLabel.font = kMainTextFieldTextFontBold16;
        [_buttonModify setTitle:@"确认修改" forState:UIControlStateNormal];
        [_buttonModify setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_buttonModify setTitleColor:kDarkGrayColor forState:UIControlStateDisabled];
        [_buttonModify jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
        [_buttonModify jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
        [_buttonModify jk_setBackgroundColor:kDarkGrayColor forState:UIControlStateDisabled];
    }
    return _buttonModify;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = kGrayLineColor;
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = kGrayLineColor;
    }
    return _line2;
}

- (UIView *)line3{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = kGrayLineColor;
    }
    return _line3;
}


#pragma mark - Layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = self.jk_width;
    CGFloat h = self.jk_height;
    CGFloat posY = 85;
    CGFloat margin = 52;
    CGFloat wExceptMargin = w - margin * 2;
    
    [self.inputPhone setFrame:CGRectMake(margin, posY, wExceptMargin, 25)];
    posY              += 35;
    [self.line1 setFrame:CGRectMake(margin, posY, w - margin * 2, 1)];
    
    posY += 23;
    CGFloat inputSmsW = wExceptMargin * 0.6;
    [self.inputSms setFrame:CGRectMake(margin, posY, inputSmsW, 25)];
    [self.buttonSms setFrame:CGRectMake(margin + inputSmsW + 10 , posY - 5, w - self.inputSms.jk_right - 62, 35)];
    posY += 35;
    [self.line2 setFrame:CGRectMake(margin, posY, inputSmsW, 1)];
    
    posY += 23;
    [self.inputPass setFrame:CGRectMake(margin, posY, wExceptMargin, 25)];
    posY += 35;
    [self.line3 setFrame:CGRectMake(margin, posY, wExceptMargin, 1)];
    
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += 24;
    }
    [self.buttonModify setFrame:CGRectMake(0, h - btnH, w, btnH)];
}


@end
