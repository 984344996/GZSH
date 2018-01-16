//
//  ApplicationStep1View.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep1View.h"
#import <JKCategories.h>

@implementation ApplicationStep1View

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.inputPhone];
    [self addSubview:self.inputSms];
    
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    
    [self addSubview:self.buttonSms];
    [self addSubview:self.buttonNext];
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

- (UIButton *)buttonNext{
    if (!_buttonNext) {
        _buttonNext = [[UIButton alloc] init];
        _buttonNext.titleLabel.font = kMainTextFieldTextFontBold16;
        [_buttonNext setTitle:@"下一步" forState:UIControlStateNormal];
        [_buttonNext setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_buttonNext setTitleColor:kDarkGrayColor forState:UIControlStateDisabled];
        [_buttonNext jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
        [_buttonNext jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
        [_buttonNext jk_setBackgroundColor:kDarkGrayColor forState:UIControlStateDisabled];
    }
    return _buttonNext;
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
    
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += kDeltaForIphoneX;
    }
    [self.buttonNext setFrame:CGRectMake(0, h - btnH, w, btnH)];
}
@end
