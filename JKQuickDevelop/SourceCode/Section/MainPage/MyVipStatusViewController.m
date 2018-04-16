//
//  MyVipStatusViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MyVipStatusViewController.h"
#import <JKCategories.h>

@interface MyVipStatusViewController ()

@end

@implementation MyVipStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Initial

- (void)configView{
    [super configView];
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


@end
