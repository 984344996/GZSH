//
//  MainPageTableHeaderView.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MainPageTableHeaderView.h"
#import "MainPageHeaderBannerCollectionViewCell.h"
#import "MainPageHeaderCollectionViewCell.h"
#import <JKCategories.h>

@interface MainPageTableHeaderView()<YJBannerViewDelegate,YJBannerViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *collectionData;
@property (nonatomic, strong) NSMutableArray *bannerModels;
@property (nonatomic, strong) NSMutableArray *noticeModels;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation MainPageTableHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)startTimer{
    [self.topBanner startTimerWhenAutoScroll];
    [self.newsBanner startTimerWhenAutoScroll];
}

- (void)stopTimer{
    [self.topBanner invalidateTimerWhenAutoScroll];
    [self.newsBanner invalidateTimerWhenAutoScroll];
}

- (void)initView{
    self.userInteractionEnabled = YES;
    self.backgroundColor = kMainBottomLayerColor;
    [self addSubview:self.topBanner];
    [self addSubview:self.collection];
    [self addSubview:self.newsBanner];
    [self addSubview:self.btnAddress];
    [self addSubview:self.btnCompanyLib];
}

#pragma mark - Setting

- (void)resetBannerModels:(NSMutableArray *)arrray{
    self.bannerModels = arrray;
    [self.imageArray removeAllObjects];
    [arrray enumerateObjectsUsingBlock:^(BannerModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imageArray addObject:GetImageString(obj.imgUrl)];
    }];
    [self.topBanner reloadData];
}

- (void)resetNewsModels:(NSMutableArray *)arrray{
    self.noticeModels = arrray;
    [self.newsBanner reloadData];
}

#pragma mark - Lazy loading
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)bannerModels{
    if (!_bannerModels) {
        _bannerModels = [NSMutableArray array];
    }
    return _bannerModels;
}

- (NSMutableArray *)noticeModels{
    if (!_noticeModels) {
        _noticeModels = [NSMutableArray array];
    }
    return _noticeModels;
}

- (YJBannerView *)topBanner{
    if (!_topBanner) {
        _topBanner              = [YJBannerView bannerViewWithFrame:CGRectZero
                                            dataSource:self
                                              delegate:self
                                  placeholderImageName:@"placeholder"     selectorString:@"sd_setImageWithURL:placeholderImage:"];
        _topBanner.autoDuration = 4;
        _topBanner.autoScroll = YES;
    }
    return _topBanner;
}

- (UICollectionView *)collection{
    if (!_collection) {
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self collectionLayout]];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [_collection registerNib:[UINib nibWithNibName:@"MainPageHeaderCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MainPageHeaderCollectionViewCell"];
    }
    return _collection;
}

- (UICollectionViewFlowLayout *)collectionLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (JK_SCREEN_WIDTH  - 24 - 42 * 3)/ 4;
    layout.itemSize = CGSizeMake(itemW, 81);
    layout.minimumInteritemSpacing = 42;
    layout.minimumLineSpacing = 42;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (YJBannerView *)newsBanner{
    if (!_newsBanner) {
        _newsBanner.backgroundColor                 = [UIColor redColor];
        _newsBanner                                 = [YJBannerView bannerViewWithFrame:CGRectZero
                                             dataSource:self
                                               delegate:self
                                   placeholderImageName:@""
                                         selectorString:nil];
        _newsBanner.pageControlStyle                = PageControlCustom;
        _newsBanner.pageControlDotSize              = CGSizeMake(12, 2);
        _newsBanner.customPageControlHighlightImage = [UIImage imageNamed:@"selected_dot"];
        _newsBanner.customPageControlNormalImage    = [UIImage imageNamed:@"normal_dot"];
        _newsBanner.bannerViewScrollDirection       = BannerViewDirectionLeft;
        _newsBanner.bannerGestureEnable             = YES;
        _newsBanner.autoScroll                      = YES;
        _newsBanner.autoDuration  =  5;
    }
    return _newsBanner;
}

- (UIButton *)btnAddress{
    if (!_btnAddress) {
        _btnAddress = [[UIButton alloc] init];
        [_btnAddress addTarget:self action:@selector(btnAddressClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnAddress setImage:[UIImage imageNamed:@"Address_List"] forState:UIControlStateNormal];
    }
    return _btnAddress;
}

- (UIButton *)btnCompanyLib{
    if (!_btnCompanyLib) {
        _btnCompanyLib = [[UIButton alloc] init];
        [_btnCompanyLib addTarget:self action:@selector(btnCompanyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnCompanyLib setImage:[UIImage imageNamed:@"Company_Lib"] forState:UIControlStateNormal];
    }
    return _btnCompanyLib;
}

- (NSArray *)collectionData{
    if (!_collectionData) {
        _collectionData = [NSArray arrayWithObjects:@[@"Home_Icon_Vip",@"会员中心"],
                           @[@"Home_Icon_Meet",@"商会会议"],
                           @[@"Home_Icon_Activity",@"商会活动"],
                           @[@"Home_Icon_News",@"商会新闻"],
                           nil];
    }
    return _collectionData;
}

#pragma mark - Events

- (void)btnAddressClicked:(UIButton *)sender{
    [self.delegate didTurnToTabIndex:2];
}

- (void)btnCompanyClicked:(UIButton *)sender{
    [self.delegate didTurnToEnterpriseCenter];
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGFloat h = JK_SCREEN_WIDTH * 0.59 + 110 + 90 + (JK_SCREEN_WIDTH / 2) * 0.54;
    return CGSizeMake(JK_SCREEN_WIDTH, h);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.jk_width;
    CGFloat posY = 0;
    
    CGRect bannerFrame = CGRectMake(0, posY, w, w * 0.59);
    [self.topBanner setFrame:bannerFrame];
    
    posY += w * 0.59;
    CGRect collectionFrame = CGRectMake(0, posY, w, 100);
    [self.collection setFrame:collectionFrame];
    
    posY += 110;
    CGRect newsBannerFrame = CGRectMake(0, posY, w, 80);
    [self.newsBanner setFrame:newsBannerFrame];
    
    posY += 90;
    CGRect btnAddressFrame = CGRectMake(0, posY, w / 2, (w / 2) * 0.54);
    CGRect btnLibFrame = CGRectMake(w / 2, posY, w / 2, (w / 2) * 0.54);
    
    [self.btnAddress setFrame:btnAddressFrame];
    [self.btnCompanyLib setFrame:btnLibFrame];
}
#pragma mark - banner Delegate and Datasource

- (void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    if (bannerView == self.topBanner) {
        [self.delegate didBannerTapped:self.bannerModels[index]];
    }else{
        [self.delegate didNewsTapped:self.noticeModels[index]];
    }
}

- (NSArray *)bannerViewImages:(YJBannerView *)bannerView{
    if (bannerView == self.topBanner) {
        return self.imageArray;
    }else{
        return self.noticeModels;
    }
}

- (NSArray *)bannerViewTitles:(YJBannerView *)bannerView{
    return @[];
}


- (Class)bannerViewCustomCellClass:(YJBannerView *)bannerView{
    if (bannerView == self.newsBanner) {
        return [MainPageHeaderBannerCollectionViewCell class];
    }
    return nil;
}

- (void)bannerView:(YJBannerView *)bannerView customCell:(UICollectionViewCell *)customCell index:(NSInteger)index{
    if (bannerView == self.newsBanner) {
        MainPageHeaderBannerCollectionViewCell *bannerCell = (MainPageHeaderBannerCollectionViewCell *)customCell;
        NewsModel *mode                                    = self.noticeModels[index];
        [bannerCell setCellData:mode];
    }
}

#pragma mark - UICollectionView delegate datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainPageHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainPageHeaderCollectionViewCell" forIndexPath:indexPath];
    NSArray *data                          = self.collectionData[indexPath.row];
    cell.icon.image                        = [UIImage imageNamed:data[0]];
    cell.nameTitle.text                    = data[1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.delegate didTurnToTabIndex:4];
    }else if(indexPath.row == 1){
        [self.delegate didTurnToTabIndex:3];
    }else if(indexPath.row == 2){
         [self.delegate didTurnToTabIndex:3];
    }else{
        [self.delegate didTurnToNewCenter];
    }
}

@end
