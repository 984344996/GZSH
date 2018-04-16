//
//  ApplicationStep4View.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep4View.h"
#import <JKCategories.h>
#import <Masonry.h>

@implementation ApplicationStep4View

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.pannelVip];
    [self.pannelVip addSubview:self.labelTitle];
    [self.pannelVip addSubview:self.imageIcon];
    
    [self addSubview:self.hintLabel];
    [self addSubview:self.buttonPay];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.pannelVip);
        make.left.equalTo(self.pannelVip);
        make.top.equalTo(self.pannelVip.mas_bottom).with.offset(5);
    }];
}

- (UIView *)pannelVip{
    if (!_pannelVip) {
        _pannelVip = [[UIView alloc] init];
        _pannelVip.layer.borderColor = kMainTextFieldBorderColor.CGColor;
        _pannelVip.layer.borderWidth = 1;
    }
    return _pannelVip;
}

- (UILabel *)labelTitle{
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.font                  = kMainTextFieldTextFontMiddle;
        _labelTitle.textColor             = kMainTextColor;
    }
    return _labelTitle;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font                  = kMainTextFieldTextFontSmall;
        _hintLabel.textColor             = kSecondTextColor;
        _hintLabel.numberOfLines         = 0;
        _hintLabel.text                  = @"会员等级图标链接（灰色图标会员等级图标链接（灰色图标会员等级图标链接（灰色图标";
    }
    return _hintLabel;
}

- (UIImageView *)imageIcon{
    if (!_imageIcon) {
        _imageIcon             = [[UIImageView alloc] init];
        _imageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _imageIcon.image = [UIImage imageNamed:@"Apply_Icon_ArrowDown"];
    }
    return _imageIcon;
}

- (UIButton *)buttonPay{
    if (!_buttonPay) {
        _buttonPay                 = [[UIButton alloc] init];
        _buttonPay.titleLabel.font = kMainTextFieldTextFontBold16;
        [_buttonPay setTitle:@"支付" forState:UIControlStateNormal];
        [_buttonPay setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_buttonPay setTitleColor:kDarkGrayColor forState:UIControlStateDisabled];
        [_buttonPay jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
        [_buttonPay jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
        [_buttonPay jk_setBackgroundColor:kDarkGrayColor forState:UIControlStateDisabled];
    }
    return _buttonPay;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat posY = 12;
    CGFloat w = self.jk_width;
    CGFloat h = self.jk_height;
    
    self.pannelVip.frame = CGRectMake(12, posY, w - 24, 50);
    self.labelTitle.frame = CGRectMake(5, 10, w - 50, 30);
    self.imageIcon.frame = CGRectMake(w - 44, 20, 10, 10);
    
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += kDeltaForIphoneX;
    }
    [self.buttonPay setFrame:CGRectMake(0, h - btnH, w, btnH)];
}


@end
