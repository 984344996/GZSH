//
//  SHMainPageViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHMainPageViewController.h"
#import "MainPageTableHeaderView.h"
#import "MySupplyAndDemandTableViewCell.h"
#import "MainPageSectionView.h"
#import <JKCategories.h>
#import "APIServerSdk.h"
#import "BannerModel.h"
#import "NewsModel.h"
#import "DemandInfo.h"
#import "NSString+Commen.h"
#import "SHWebViewViewController.h"
#import "MySupplyAndDemandViewController.h"
#import <MJExtension.h>
#import <ReactiveObjC.h>
#import "MySupplyDetailViewController.h"
#import "MySupplyAndDemandViewController.h"
#import "SHEnterpriseViewController.h"
#import "AppUtils.h"
#import "UnPayModel.h"
#import "JKSelectedListView.h"
#import "ThirdPayHelper.h"
#import <LEEAlert.h>

@interface SHMainPageViewController ()<MainPageTableHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *demands;
@property (nonatomic, strong) NSMutableArray *bannerModels;
@property (nonatomic, strong) NSMutableArray *noticeModels;
@property (nonatomic, assign) NSInteger cacheIndex;
@property (nonatomic, strong) MainPageSectionView *sectionHeader;
@property (nonatomic, strong) MainPageTableHeaderView *header;
@end

@implementation SHMainPageViewController

- (void)configView{
    [super configView];
    
    self.isOpenHeaderRefresh = YES;
    self.tableView.tableHeaderView = self.header;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MySupplyAndDemandTableViewCell" bundle:nil] forCellReuseIdentifier:@"MySupplyAndDemandTableViewCell"];
    [self.tableView.mj_header beginRefreshing];
}

- (void)configEvent{
    [super configEvent];
    
    self.sectionHeader.userInteractionEnabled = YES;
    UITapGestureRecognizer *gen = [[UITapGestureRecognizer alloc] init];
    [self.sectionHeader addGestureRecognizer:gen];
    
    @weakify(self);
    [[gen rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        if (!self.hasAccessPermisson) {
            [self showNoAccessPermissionDialog];
            return;
        }
        MySupplyAndDemandViewController *vc = [[MySupplyAndDemandViewController alloc] initWithUserId:nil isSelf:NO];
        self.hidesBottomBarWhenPushed       = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed       = NO;
    }];
}

- (void)configData{
    [super configData];
    [self checkForUnPay];
    [AppUtils fetchDynamicMsgCount];
}

- (void)headerRefresh{
    [self loadBanner];
    [self loadNewsNotice];
    [self loadDemand];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.header startTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.header stopTimer];
}

#pragma mark - Lazy loading

- (MainPageTableHeaderView *)header{
    if (!_header) {
        _header = [[MainPageTableHeaderView alloc] init];
        _header.delegate = self;
        [_header sizeToFit];
    }
    return _header;
}


- (void)setBannerModels:(NSMutableArray *)bannerModels{
    [self.tableView.mj_header endRefreshing];
    if (!bannerModels.count) {
        return;
    }
    _bannerModels = bannerModels;
    [self.header resetBannerModels:bannerModels];
}

- (void)setNoticeModels:(NSMutableArray *)noticeModels{
    [self.tableView.mj_header endRefreshing];
    if (!noticeModels.count) {
        return;
    }
    _noticeModels = noticeModels;
    [self.header resetNewsModels:noticeModels];
}

- (void)setDemands:(NSMutableArray *)demands{
    [self.tableView.mj_header endRefreshing];
    if (!demands.count) {
        return;
    }
    _demands = demands;
    [self.tableView reloadData];
}

- (MainPageSectionView *)sectionHeader{
    if (!_sectionHeader) {
        _sectionHeader = [[MainPageSectionView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, 40)];

    }
    return _sectionHeader;
}

#pragma mark - APIServer

/// banner
- (void)loadBanner{
    self.cacheIndex += 1;
    [APIServerSdk doGetBanner:^(id obj) {
        NSMutableArray *models = [BannerModel mj_objectArrayWithKeyValuesArray:obj];
        self.bannerModels = models;
    } needCache:self.cacheIndex <= 3 cacheSucceed:^(id obj) {
        NSMutableArray *models = [BannerModel mj_objectArrayWithKeyValuesArray:obj];
        self.bannerModels = models;
    } failed:^(NSString *error) {
        
    }];
}

/// 新闻公告
- (void)loadNewsNotice{
    self.cacheIndex += 1;
    [APIServerSdk doGetNews:1 max:10 type:nil succeed:^(id obj) {
        NSMutableArray *models = [NewsModel mj_objectArrayWithKeyValuesArray:obj];
        self.noticeModels = models;
    } needCache:self.cacheIndex <= 3 cacheSucceed:^(id obj) {
        NSMutableArray *models = [NewsModel mj_objectArrayWithKeyValuesArray:obj];
        self.noticeModels = models;
    } failed:^(NSString *error) {

    }];
}

/// 供求信息
- (void)loadDemand{
    self.cacheIndex += 1;
    [APIServerSdk doGetDemand:1 max:10 succeed:^(id obj) {
        CommonResponseModel *model = obj;
        NSMutableArray *models = [DemandInfo mj_objectArrayWithKeyValuesArray:model.data];
        self.demands = models;
    } needCache:self.cacheIndex <= 3 cacheSucceed:^(id obj) {
        CommonResponseModel *model = obj;
        NSMutableArray *models = [DemandInfo mj_objectArrayWithKeyValuesArray:model.data];
        self.demands = models;
    } failed:^(NSString *error) {
    }];
}

/// 是否需要付费

- (void)checkForUnPay{
    WEAKSELF
    [APIServerSdk doFindUnpaid:^(id obj) {
        STRONGSELF
        CommonResponseModel *response = (CommonResponseModel *)obj;
        UnPayModel *model = [UnPayModel mj_objectWithKeyValues:response.data];
        if (!model) {
            return ;
        }
        [strongSelf tipToPay:model];
    } failed:^(NSString *error) {
    }];
}

- (void)tipToPay:(UnPayModel *)model{
    [LEEAlert alert]
    .config
    .LeeTitle(@"有未支付订单")
    .LeeCancelAction(@"取消", ^{
    })
    .LeeAction(@"去支付", ^{
        [self chooseToPay:model];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = [NSString stringWithFormat:@"您购买商会【%@】会员的%.2f元未支付！",model.vipName,model.price.floatValue];
        label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
        label.textAlignment = NSTextAlignmentCenter;
    })
    .LeeShow();
}

- (void)chooseToPay:(UnPayModel *)model{
    NSArray *array = @[@{@"name":@"微信支付",@"type":@"wx"},@{@"name":@"支付宝支付",@"type":@"alipay"}];
    JKSelectedListView *view = [[JKSelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle            = YES;
    view.array               = array;
    view.titleKey            = @"name";
    
    WEAKSELF
    view.selectedBlock = ^(NSArray *array) {
        [LEEAlert closeWithCompletionBlock:^{
            STRONGSELF
            NSUInteger index = [array indexOfObject:[array firstObject]];
            NSObject *obj = array[index];
            NSString *type = [obj valueForKey:@"type"];
            [strongSelf doPayUnPay:type];
        }];
    };
    NSString *title = @"请选择支付方式";
    [LEEAlert alert].config
    .LeeTitle(title)
    .LeeCustomView(view)
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}

- (void)doPayUnPay:(NSString *)channel{
    WEAKSELF
    [APIServerSdk doBuy:channel succeed:^(id obj) {
        STRONGSELF
        CommonResponseModel *model = (CommonResponseModel *)obj;
        PayModel *payModel = [PayModel mj_objectWithKeyValues:(model.data)];
        [[ThirdPayHelper sharedInstance] thirdPay:channel payModel:payModel callback:^(PayType type, PayResult result, NSString *message) {
            if (result == PayResultSuccess) {
                [[HUDHelper sharedInstance] tipMessage:@"支付成功" inView:strongSelf.view];
            }else{
                [[HUDHelper sharedInstance] tipMessage:@"支付失败" inView:strongSelf.view];
            }
        }];
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] tipMessage:@"支付失败" inView:strongSelf.view];
    }];
}


#pragma mark - Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.demands.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MySupplyAndDemandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MySupplyAndDemandTableViewCell" forIndexPath:indexPath];
    DemandInfo *model           = self.demands[indexPath.row];
    [cell setCellData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self doEnterDetail:indexPath];
}


- (void)doEnterDetail:(NSIndexPath *)index{
    if (!self.hasAccessPermisson) {
        [self showNoAccessPermissionDialog];
        return;
    }
    MySupplyDetailViewController *vc = [[MySupplyDetailViewController alloc] initWithDemand:self.demands[index.row] isSelf:NO];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - MainPageTableHeaderViewDelegate

- (void)didBannerTapped:(BannerModel *)bannerModel{
    if ([bannerModel.type isEqualToString:@"LINK"]) {
        SHWebViewViewController *vc = [[SHWebViewViewController alloc] initWithUrl:[NSString GetH5Url:bannerModel.url]];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)didNewsTapped:(NewsModel *)newsModel{
    SHWebViewViewController *vc = [[SHWebViewViewController alloc] initWithUrl:[NSString GetH5Url:newsModel.url]];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/// 会议
- (void)didTurnToSHMeeting:(NSUInteger)index{
    [self.tabBarController setSelectedIndex:index];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kJKMeetingActivityRefresh object:nil userInfo:@{@"type":@"MEETING"}];
    });
}

/// 活动
- (void)didTurnToSHActivity:(NSUInteger)index{
    [self.tabBarController setSelectedIndex:index];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kJKMeetingActivityRefresh object:nil userInfo:@{@"type":@"ACTIVITY"}];
    });
}

- (void)didTurnToIndex:(NSUInteger)index{
    [self.tabBarController setSelectedIndex:index];
}

- (void)didTurnToNewCenter{
    SHWebViewViewController *vc = [[SHWebViewViewController alloc] initWithUrl:[NSString GetH5Url:[NSString stringWithFormat:@"%@%@",BaseFileUrl,@"/h5/news.html"]]];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didTurnToEnterpriseCenter{
    if (!self.hasAccessPermisson) {
        [self showNoAccessPermissionDialog];
        return;
    }
    SHEnterpriseViewController *vc = [[SHEnterpriseViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
