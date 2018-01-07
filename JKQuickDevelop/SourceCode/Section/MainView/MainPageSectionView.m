//
//  MainPageSectionView.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MainPageSectionView.h"
#import <Masonry.h>

@implementation MainPageSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self doLayout];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.leftBar];
    [self addSubview:self.title];
    [self addSubview:self.moreText];
    [self addSubview:self.moreIcon];
}

- (void)doLayout{
    [self.leftBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(2, 18));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBar).with.offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self.moreIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 16));
    }];
    
    [self.moreText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreIcon.mas_left).with.offset(-5);
        make.centerY.equalTo(self);
    }];
    
}

#pragma mark - Lazy loading

- (UIView *)leftBar{
    if (!_leftBar) {
        _leftBar = [[UIView alloc] init];
        _leftBar.layer.cornerRadius = 0.5;
        _leftBar.layer.masksToBounds = YES;
        _leftBar.backgroundColor = RGB(14, 147, 255);
    }
    return _leftBar;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = kMainTextFieldTextFontMiddle;
        _title.textColor = kMainTextColor;
        _title.text = @"供求信息";
    }
    return _title;
}


- (UILabel *)moreText{
    if (!_moreText) {
        _moreText = [[UILabel alloc] init];
        _moreText.font = kMainTextFieldTextFontMiddle;
        _moreText.textColor = kSecondTextColor;
        _moreText.text = @"更多";
    }
    return _moreText;
}

- (UIImageView *)moreIcon{
    if (!_moreIcon) {
        _moreIcon = [[UIImageView alloc] init];
        _moreIcon.contentMode = UIViewContentModeScaleAspectFit;
        _moreIcon.image = [UIImage imageNamed:@"Circle_Arrow_Right"];
    }
    return _moreIcon;
}

@end
