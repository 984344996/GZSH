//
//  AddressTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "AddressTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Public methods

- (void)setupCellData:(Contact *)data{
    self.labelName.text    = data.userName;
    self.labelPhone.text   = data.mobile;
    self.labelCompany.text = data.enterprise;
    [self.imageAvatar sd_setImageWithURL:GetImageUrl(data.avatar) placeholderImage:kPlaceHoderHeaderImage];
}

- (void)setupCellDataEnterprise:(EnterpriseModelExt *)data{
    self.labelName.text    = data.name;
    self.labelPhone.text   = data.userMobile;
    self.labelCompany.text = data.username;
    [self.imageAvatar sd_setImageWithURL:GetImageUrl(data.userAvatar) placeholderImage:kPlaceHoderHeaderImage];
}

@end
