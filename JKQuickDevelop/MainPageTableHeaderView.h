//
//  MainPageTableHeaderView.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YJBannerView.h>
#import "NewsModel.h"
#import "BannerModel.h"

@protocol MainPageTableHeaderViewDelegate <NSObject>
- (void)didBannerTapped:(BannerModel *)bannerModel;
- (void)didNewsTapped:(NewsModel *)newsModel;
- (void)didTurnToSHMeeting:(NSUInteger)index;
- (void)didTurnToSHActivity:(NSUInteger)index;
- (void)didTurnToIndex:(NSUInteger)index;
- (void)didTurnToNewCenter;
- (void)didTurnToEnterpriseCenter;
@end

@interface MainPageTableHeaderView : UIView

@property (nonatomic, strong) YJBannerView *topBanner;
@property (nonatomic, strong) YJBannerView *newsBanner;

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) UIButton *btnAddress;
@property (nonatomic, strong) UIButton *btnCompanyLib;
@property (nonatomic, weak) id<MainPageTableHeaderViewDelegate> delegate;

- (void)resetNewsModels:(NSMutableArray *)arrray;
- (void)resetBannerModels:(NSMutableArray *)arrray;

- (void)startTimer;
- (void)stopTimer;

@end

