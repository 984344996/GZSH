//
//  MySupplyAndDemandViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MySupplyAndDemandViewController.h"
#import "DemandInfo.h"
#import "MySupplyAndDemandTableViewCell.h"
#import "MySupplyAndDemandEditViewController.h"
#import "APIServerSdk.h"
#import "CommonResponseModel.h"
#import <MJExtension.h>
#import "MySupplyDetailViewController.h"


@interface MySupplyAndDemandViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *supplies;
@end

@implementation MySupplyAndDemandViewController

- (instancetype)initWithUserId:(NSString *)userId isSelf:(BOOL)isSelf{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.userId = userId;
        self.isSelf = isSelf;
        self.page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    
    if (self.isSelf) {
        self.title = @"我的供求信息";
        [self addUIBarButtonItemText:@"发布" isLeft:NO target:self action:@selector(doPublish:)];
    }else{
        self.title = @"供求信息";
    }
    
    self.tableView.separatorColor = kGrayLineColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"MySupplyAndDemandTableViewCell" bundle:nil] forCellReuseIdentifier:@"MySupplyAndDemandTableViewCell"];
}

- (void)configData{
    [super configData];
    [self loadData:YES];
}


- (NSMutableArray *)supplies{
    if (!_supplies) {
        _supplies = [NSMutableArray array];
    }
    return _supplies;
}

#pragma mark - APIServer

- (void)loadData:(BOOL)isRefresh{
    if (self.isSelf) {
        [self loadSelfDemands:isRefresh];
    }else if(self.userId){
        [self loadOtherDemands:isRefresh];
    }else{
        [self loadMainPageDemands:isRefresh];
    }
}

- (void)loadSelfDemands:(BOOL)isRefresh{
    WEAKSELF
    [APIServerSdk doLoadOwnDemands:self.page succeed:^(id obj) {
        STRONGSELF
        if (isRefresh) {
            [strongSelf.supplies removeAllObjects];
        }
        CommonResponseModel *model = obj;
        NSMutableArray *append = [DemandInfo mj_objectArrayWithKeyValuesArray:model.data];
        [strongSelf.supplies addObjectsFromArray:append];
        [strongSelf.tableView reloadData];
    } failed:^(NSString *error) {
        
    }];
}

- (void)loadOtherDemands:(BOOL)isRefresh{
    WEAKSELF
    [APIServerSdk doLoadOtherDemands:self.userId page:self.page succeed:^(id obj) {
        STRONGSELF
        if (isRefresh) {
            [strongSelf.supplies removeAllObjects];
        }
        CommonResponseModel *model = obj;
        NSMutableArray *append = [DemandInfo mj_objectArrayWithKeyValuesArray:model.data];
        [strongSelf.supplies addObjectsFromArray:append];
        [strongSelf.tableView reloadData];
    } failed:^(NSString *error) {
    }];
}

- (void)loadMainPageDemands:(BOOL)isRefresh{
    WEAKSELF
    [APIServerSdk doGetDemand:self.page max:20 succeed:^(id obj) {
        STRONGSELF
        if (isRefresh) {
            [strongSelf.supplies removeAllObjects];
        }
        CommonResponseModel *model = obj;
        NSMutableArray *append = [DemandInfo mj_objectArrayWithKeyValuesArray:model.data];
        [strongSelf.supplies addObjectsFromArray:append];
        [strongSelf.tableView reloadData];
    } needCache:NO cacheSucceed:nil failed:^(NSString *error) {
    }];
}

#pragma mark - Private methods

- (void)doPublish:(UIBarButtonItem *)sender{
    MySupplyAndDemandEditViewController *vc = [[MySupplyAndDemandEditViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)doEnterDetail:(NSIndexPath *)index{
    MySupplyDetailViewController *vc = [[MySupplyDetailViewController alloc] initWithDemand:self.supplies[index.row] isSelf:self.isSelf];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - Table Delegate and Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.supplies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MySupplyAndDemandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MySupplyAndDemandTableViewCell" forIndexPath:indexPath];
    [cell setCellData:self.supplies[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self doEnterDetail:indexPath];
}

@end
