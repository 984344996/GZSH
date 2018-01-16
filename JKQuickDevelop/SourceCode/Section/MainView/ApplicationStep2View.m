//
//  ApplicationStep2View.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep2View.h"
#import <JKCategories.h>
#import <Masonry.h>

@interface ApplicationStep2View()
@property (nonatomic, strong) UIImageView *icon1;
@property (nonatomic, strong) UIImageView *icon2;
@end

@implementation ApplicationStep2View

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.containerView];
    [self addSubview:self.btnNext];
    
    [self.containerView addSubview:self.labelImage];
    [self.containerView addSubview:self.btnImage];
    [self.containerView addSubview:self.btnReupload];
    
    [self.containerView addSubview:self.labelName];
    [self.containerView addSubview:self.inputName];
    
    [self.containerView addSubview:self.labelAddress];
    [self.containerView addSubview:self.inputAddressProvince];
    [self.containerView addSubview:self.inputAddressCity];
    
    [self.containerView addSubview:self.labelCompay];
    [self.containerView addSubview:self.inputCompany];
    
    [self.containerView addSubview:self.labelCompayPosition];
    [self.containerView addSubview:self.inpputCompayPosition];
    
    [self.containerView addSubview:self.labelCompayInfo];
    [self.containerView addSubview:self.inputCompanyInfo];
    
    _icon1 = [[UIImageView alloc] init];
    _icon1.image = [UIImage imageNamed:@"Apply_Icon_ArrowDown"];
    _icon2 = [[UIImageView alloc] init];
    _icon2.image = [UIImage imageNamed:@"Apply_Icon_ArrowDown"];
    
    [self.inputAddressProvince addSubview:self.icon1];
    [self.inputAddressCity addSubview:self.icon2];
    
    [self.icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputAddressProvince).with.offset(-5);
        make.centerY.equalTo(self.inputAddressProvince);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputAddressCity).with.offset(-5);
        make.centerY.equalTo(self.inputAddressCity);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
}

#pragma mark - Lazy loading


- (UIScrollView *)containerView{
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] init];
        _containerView.showsVerticalScrollIndicator = NO;
    }
    return _containerView;
}

- (UILabel *)labelImage{
    if (!_labelImage) {
        _labelImage = [[UILabel alloc] init];
        _labelImage.text = @"照片：";
        _labelImage.font = kMainTextFieldTextFontMiddle;
        _labelImage.textColor = kSecondTextColor;
    }
    return _labelImage;
}

- (UILabel *)labelName{
    if (!_labelName) {
        _labelName = [[UILabel alloc] init];
        _labelName.text = @"真实姓名：";
        _labelName.font = kMainTextFieldTextFontMiddle;
        _labelName.textColor = kSecondTextColor;
    }
    return _labelName;
}

- (UILabel *)labelAddress{
    if (!_labelAddress) {
        _labelAddress = [[UILabel alloc] init];
        _labelAddress.text = @"家乡地址：";
        _labelAddress.font = kMainTextFieldTextFontMiddle;
        _labelAddress.textColor = kSecondTextColor;
    }
    return _labelAddress;
}

- (UILabel *)labelCompay{
    if (!_labelCompay) {
        _labelCompay = [[UILabel alloc] init];
        _labelCompay.text = @"所属企业：";
        _labelCompay.font = kMainTextFieldTextFontMiddle;
        _labelCompay.textColor = kSecondTextColor;
    }
    return _labelCompay;
}

- (UILabel *)labelCompayPosition{
    if (!_labelCompayPosition) {
        _labelCompayPosition = [[UILabel alloc] init];
        _labelCompayPosition.text = @"公司职位：";
        _labelCompayPosition.font = kMainTextFieldTextFontMiddle;
        _labelCompayPosition.textColor = kSecondTextColor;
    }
    return _labelCompayPosition;
}

- (UILabel *)labelCompayInfo{
    if (!_labelCompayInfo) {
        _labelCompayInfo = [[UILabel alloc] init];
        _labelCompayInfo.text = @"公司简介：";
        _labelCompayInfo.font = kMainTextFieldTextFontMiddle;
        _labelCompayInfo.textColor = kSecondTextColor;
    }
    return _labelCompayInfo;
}

- (UIButton *)btnImage{
    if (!_btnImage) {
        _btnImage = [[UIButton alloc] init];
        [_btnImage setImage:[UIImage imageNamed:@"Apply_Icon_UploadingPicture"] forState:UIControlStateNormal];
        [_btnImage setBackgroundColor: RGB(216, 216, 216)];
        [_btnImage setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    }
    return _btnImage;
}

- (UIButton *)btnReupload{
    if (!_btnReupload) {
        _btnReupload = [[UIButton alloc] init];
        [_btnReupload setTitle:@"上传头像" forState:UIControlStateNormal];
        [_btnReupload setTitleColor:kMainBlueColor forState:UIControlStateNormal];
        [_btnReupload.titleLabel setFont:kMainTextFieldTextFontSmall];
    }
    return _btnReupload;
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

- (JKTextField_Padding *)inputName{
    if (!_inputName) {
        _inputName =  [[JKTextField_Padding alloc] init];
        _inputName.font = kMainTextFieldTextFontMiddle;
        _inputName.textColor = kMainTextColor;
        _inputName.borderColor = kMainTextFieldBorderColor;
        _inputName.borderW = 1;
        _inputName.placeholder = @"请输入...";
        _inputName.leftPadding = 5;
    }
    return _inputName;
}

- (UILabel *)inputAddressProvince{
    if (!_inputAddressProvince) {
        _inputAddressProvince =  [[UILabel alloc] init];
        _inputAddressProvince.layer.borderColor = kMainTextFieldBorderColor.CGColor;
        _inputAddressProvince.layer.borderWidth = 1;
        _inputAddressProvince.textColor = kSecondTextColor;
        _inputAddressProvince.font = kMainTextFieldTextFontMiddle;
        _inputAddressProvince.text = @" -省-";
    }
    return _inputAddressProvince;
}

- (UILabel *)inputAddressCity{
    if (!_inputAddressCity) {
        _inputAddressCity =  [[UILabel alloc] init];
        _inputAddressCity.layer.borderColor = kMainTextFieldBorderColor.CGColor;
        _inputAddressCity.layer.borderWidth = 1;
        _inputAddressCity.textColor = kSecondTextColor;
        _inputAddressCity.font = kMainTextFieldTextFontMiddle;
        _inputAddressCity.text = @" -市-";
    }
    return _inputAddressCity;
}

- (JKTextField_Padding *)inputCompany{
    if (!_inputCompany) {
        _inputCompany =  [[JKTextField_Padding alloc] init];
        _inputCompany.font = kMainTextFieldTextFontMiddle;
        _inputCompany.textColor = kMainTextColor;
        _inputCompany.borderColor = kMainTextFieldBorderColor;
        _inputCompany.borderW = 1;
        _inputCompany.placeholder = @"请输入...";
        _inputCompany.leftPadding = 5;
    }
    return _inputCompany;
}

- (JKTextField_Padding *)inpputCompayPosition{
    if (!_inpputCompayPosition) {
        _inpputCompayPosition =  [[JKTextField_Padding alloc] init];
        _inpputCompayPosition.font = kMainTextFieldTextFontMiddle;
        _inpputCompayPosition.textColor = kMainTextColor;
        _inpputCompayPosition.borderColor = kMainTextFieldBorderColor;
        _inpputCompayPosition.borderW = 1;
        _inpputCompayPosition.placeholder = @"请输入...";
        _inpputCompayPosition.leftPadding = 5;
    }
    return _inpputCompayPosition;
}

- (UITextView *)inputCompanyInfo{
    if (!_inputCompanyInfo) {
        _inputCompanyInfo = [[UITextView alloc] init];
        _inputCompanyInfo.font = kMainTextFieldTextFontMiddle;
        _inputCompanyInfo.textColor = kMainTextColor;
        _inputCompanyInfo.layer.borderColor = kMainTextFieldBorderColor.CGColor;
        _inputCompanyInfo.layer.borderWidth = 1;
        _inputCompanyInfo.placeholder = @"企业简介不少于30字，不多于200字";
    }
    return _inputCompanyInfo;
}

- (void)layoutSubviews{
    CGFloat posY = 25;
    CGFloat margin = 12;
    CGFloat w = self.jk_width;
    CGFloat h = self.jk_height;
    
    self.labelImage.frame = CGRectMake(40, posY, 50, 20);
    self.btnImage.frame = CGRectMake(90, posY, 60, 60);
    self.btnReupload.frame = CGRectMake(152, 55, 58, 40);
    
    posY = 113;
    
    self.labelName.frame = CGRectMake(margin, posY, 72, 20);
    self.inputName.frame = CGRectMake(84, posY - 2, w - 96, 24);
    
    
    posY += 50;
    self.labelAddress.frame = CGRectMake(margin, posY, 72, 20);
    CGFloat itemW = (w - 123) / 2;
    self.inputAddressProvince.frame = CGRectMake(84, posY - 2, itemW, 24);
    self.inputAddressCity.frame = CGRectMake(84 + itemW + 27, posY - 2, itemW, 24);
    
    posY += 50;
    self.labelCompay.frame = CGRectMake(margin, posY, 72, 20);
    self.inputCompany.frame = CGRectMake(84, posY - 2, w - 96, 24);
    
    posY += 50;
    self.labelCompayPosition.frame = CGRectMake(margin, posY, 72, 20);
    self.inpputCompayPosition.frame = CGRectMake(84, posY - 2, w - 96, 24);
    
    posY += 50;
    self.labelCompayInfo.frame = CGRectMake(margin, posY, 72, 20);
    self.inputCompanyInfo.frame = CGRectMake(84, posY - 2, w - 96, 150);
    posY += 150;
    
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += kDeltaForIphoneX;
    }
    [self.btnNext setFrame:CGRectMake(0, h - btnH, w, btnH)];
    [self.containerView setFrame:CGRectMake(0, 0, w, h - btnH)];
    [self.containerView setContentSize:CGSizeMake(w, posY)];
}

@end
