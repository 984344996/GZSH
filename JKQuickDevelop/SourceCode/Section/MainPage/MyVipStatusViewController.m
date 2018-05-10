//
//  MyVipStatusViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MyVipStatusViewController.h"
#import <JKCategories.h>
#import "UserInfo.h"
#import "AppDataFlowHelper.h"
#import "VipInfo.h"
#import <UIImageView+WebCache.h>
#import "NSDate+Common.h"
#import "APIServerSdk.h"
#import <MJExtension.h>
#import <ReactiveObjC.h>
#import "MyVipRenewViewController.h"

@interface MyVipStatusViewController ()

@end

@implementation MyVipStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Initial

- (void)configView{
    [super configView];
    self.title = @"我的会员";
    self.view.backgroundColor        = kMainBottomLayerColor;

    self.buttonRenew.titleLabel.font = kMainTextFieldTextFontBold16;
    [self.buttonRenew setTitle:@"续费" forState:UIControlStateNormal];
    [self.buttonRenew setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.buttonRenew setTitleColor:kDarkGrayColor forState:UIControlStateDisabled];
    [self.buttonRenew jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
    [self.buttonRenew jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
    [self.buttonRenew jk_setBackgroundColor:kDarkGrayColor forState:UIControlStateDisabled];
    
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += kDeltaForIphoneX;
    }
    self.constraintButtonHeight.constant = btnH;
}

- (void)configData{
    [super configData];
    [self refreshUserInfo];
    
    UserInfo *myInfo = [AppDataFlowHelper getLoginUserInfo];
    [self setUserInfo:myInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUserInfo];
}

- (void)configEvent{
    [super configEvent];
    @weakify(self)
    [[self.buttonRenew rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        MyVipRenewViewController *renewVC = [[MyVipRenewViewController alloc] init];
        renewVC.charmTitleLast = [AppDataFlowHelper getLoginUserInfo].chamTitle;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:renewVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;;
    }];
}

#pragma mark - Private methods
- (void)refreshUserInfo{
    NSString *userId = [AppDataFlowHelper getLoginUserInfo].userId;
    if (!userId) {
        return;
    }
    [APIServerSdk doGetUserInfo:userId needCache:NO cacheSucceed:nil succeed:^(id obj) {
        UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:obj];
        [AppDataFlowHelper saveLoginUserInfo:userInfo];
        [self setUserInfo:userInfo];
    } failed:^(NSString *error) {
    }];
}

- (void)setUserInfo:(UserInfo *)info{
    VipInfo *vip = [AppDataFlowHelper getVipInfoOfCharmTitle:info.chamTitle];
    self.labelCharm.text = vip.name;
    if ([info.vipState isEqualToString:@"VALID"]) {
        [self.imageIcon sd_setImageWithURL:GetImageUrl(vip.icon) placeholderImage:kPlaceHoderHeaderImage];
    }else{
        [self.imageIcon sd_setImageWithURL:GetImageUrl(vip.iconGray) placeholderImage:kPlaceHoderHeaderImage];
    }
    self.labelTime.text = info.vipExpires;
    NSDate *vipExpire = [NSDate getDateFromDateString:info.vipExpires];
    if ([vipExpire timeIntervalSinceNow] < 1296000) {
        [self.buttonRenew setHidden:NO];
    }else{
        [self.buttonRenew setHidden:YES];
    }
}


@end
