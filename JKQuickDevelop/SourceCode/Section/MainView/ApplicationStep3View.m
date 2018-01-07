//
//  ApplicationStep3View.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep3View.h"
#import <JKCategories.h>

@implementation ApplicationStep3View

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.labelPhone];
    [self addSubview:self.inputPhone];
    [self addSubview:self.labelAppend];
    [self addSubview:self.inputAppend];
    [self addSubview:self.btnNext];
}

#pragma mark - Lazy Loading

- (UILabel *)labelPhone{
    if (!_labelPhone) {
        _labelPhone = [[UILabel alloc] init];
        _labelPhone.text = @"推荐人手机号：";
        _labelPhone.font = kMainTextFieldTextFontMiddle;
        _labelPhone.textColor = kSecondTextColor;
    }
    return _labelPhone;
}

- (UILabel *)labelAppend{
    if (!_labelAppend) {
        _labelAppend = [[UILabel alloc] init];
        _labelAppend.text = @"其他补充信息：";
        _labelAppend.font = kMainTextFieldTextFontMiddle;
        _labelAppend.textColor = kSecondTextColor;
    }
    return _labelAppend;
}

- (JKTextField_Padding *)inputPhone{
    if (!_inputPhone) {
        _inputPhone =  [[JKTextField_Padding alloc] init];
        _inputPhone.borderColor = kMainTextFieldBorderColor;
        _inputPhone.font = kMainTextFieldTextFontMiddle;
        _inputPhone.textColor = kMainTextColor;
        _inputPhone.borderW = 1;
        _inputPhone.placeholder = @"没有则不填";
        _inputPhone.leftPadding = 5;
    }
    return _inputPhone;
}

- (UITextView *)inputAppend{
    if (!_inputAppend) {
        _inputAppend = [[UITextView alloc] init];
        _inputAppend.font = kMainTextFieldTextFontMiddle;
        _inputAppend.textColor = kMainTextColor;
        _inputAppend.layer.borderColor = kMainTextFieldBorderColor.CGColor;
        _inputAppend.layer.borderWidth = 1;
        _inputAppend.placeholder = @"企业简介不少于30字，不多于200字";
        _inputAppend.placeholderLabel.font = kMainTextFieldTextFontMiddle;
    }
    return _inputAppend;
}

- (UIButton *)btnNext{
    if (!_btnNext) {
        _btnNext = [[UIButton alloc] init];
        _btnNext.titleLabel.font = kMainTextFieldTextFontBold16;
        [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
        [_btnNext setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_btnNext setTitleColor:kDarkGrayColor forState:UIControlStateDisabled];
        [_btnNext jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
        [_btnNext jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
        [_btnNext jk_setBackgroundColor:kDarkGrayColor forState:UIControlStateDisabled];
    }
    return _btnNext;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat posY = 25;
    CGFloat margin = 12;
    CGFloat w = self.jk_width;
    CGFloat h = self.jk_height;
    
    self.labelPhone.frame = CGRectMake(margin, posY, 100, 20);
    self.inputPhone.frame = CGRectMake(112, posY - 2, w - 124, 24);
    
    posY += 52;
    self.labelAppend.frame = CGRectMake(margin, posY, 100, 20);
    self.inputAppend.frame = CGRectMake(112, posY - 2, w - 124, 150);
    
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += 24;
    }
    [self.btnNext setFrame:CGRectMake(0, h - btnH, w, btnH)];
}

@end
