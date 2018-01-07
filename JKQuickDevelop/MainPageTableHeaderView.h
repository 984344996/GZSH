//
//  MainPageTableHeaderView.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YJBannerView.h>

@interface MainPageTableHeaderView : UIView

@property (nonatomic, strong) YJBannerView *topBanner;
@property (nonatomic, strong) YJBannerView *newsBanner;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) UIButton *btnAddress;
@property (nonatomic, strong) UIButton *btnCompanyLib;

@end

