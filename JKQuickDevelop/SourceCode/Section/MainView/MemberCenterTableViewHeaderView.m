//
//  MemberCenterTableViewHeaderView.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MemberCenterTableViewHeaderView.h"
#import <UIImageView+WebCache.h>

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
    self.nameLabel.text       = userInfo.userName;
    self.shPositionLabel.text = userInfo.chamTitle;
    self.companyLabel.text    = userInfo.enterprise.name;
    self.companyPositionLabel.text = userInfo.enterpriseTitle;
}


@end
