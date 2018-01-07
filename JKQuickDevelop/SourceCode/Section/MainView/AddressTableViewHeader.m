//
//  AddressTableViewHeader.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "AddressTableViewHeader.h"
#import <Masonry.h>

@interface AddressTableViewHeader()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *container;
@end

@implementation AddressTableViewHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView{
    self.backgroundColor = kMainBottomLayerColor;
    [self addSubview:self.container];
    [self.container addSubview:self.icon];
    [self.container addSubview:self.inputFilterKey];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(12, 12, 6, 12));
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container).with.offset(10);
        make.centerY.equalTo(self.container);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.inputFilterKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(10);
        make.centerY.equalTo(self.container);
        make.right.equalTo(self.container).with.offset(-10);
    }];
}

- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(JK_SCREEN_WIDTH, 60);
}

#pragma mark - lazy loading

- (UIView *)container{
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = kWhiteColor;
    }
    return _container;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"AddressBook_Icon_Search"];
    }
    return _icon;
}

- (UITextField *)inputFilterKey{
    if (!_inputFilterKey) {
        _inputFilterKey = [[UITextField alloc] init];
        _inputFilterKey.textColor = kMainTextColor;
        _inputFilterKey.font = kMainTextFieldTextFontMiddle;
        _inputFilterKey.placeholder = @"请输入会员姓名/企业/手机号码";
    }
    return _inputFilterKey;
}

@end
