//
//  MemberCenterTableViewHeaderView.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MemberCenterTableViewHeaderView.h"
#import <UIImageView+WebCache.h>
#import "AppDataFlowHelper.h"

@implementation MemberCenterTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _header = [[[NSBundle mainBundle] loadNibNamed:@"MemberCenterTableViewHeaderView" owner:self options:nil] firstObject];
        [self addSubview:_header];
        _header.frame = frame;
        [_header setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    [self.avatar sd_setImageWithURL:GetImageUrl(userInfo.avatar) placeholderImage:kPlaceHoderHeaderImage];
    self.nameLabel.text            = userInfo.userName;
    if (userInfo.enterprise.name) {
    self.companyLabel.text         = userInfo.enterprise.name;
    }
    if (userInfo.enterpriseTitle) {
        self.companyPositionLabel.text = [NSString stringWithFormat:@"公司职位：%@",userInfo.enterpriseTitle];
    }
    
    VipInfo *info = [AppDataFlowHelper getVipInfoOfCharmTitle:userInfo.chamTitle];
    self.shPositionLabel.text      = info.name;
    self.vipInfoLabel.text         = info.name;
    if ([userInfo.vipState isEqualToString:@"VALID"]) {
        [self.iconVipImage sd_setImageWithURL:GetImageUrl(info.icon) placeholderImage:kPlaceHoderHeaderImage];
    }else{
         [self.iconVipImage sd_setImageWithURL:GetImageUrl(info.iconGray) placeholderImage:kPlaceHoderHeaderImage];
    }
}

@end
