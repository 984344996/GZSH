//
//  SHActivityViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHActivityViewController.h"
#import "ActivityTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "SHActivityDetailViewController.h"
#import "APIServerSdk.h"
#import "MettingModel.h"
#import <MJExtension.h>
#import <ReactiveObjC.h>
#import "CommonResponseModel.h"

@interface SHActivityViewController ()
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSMutableArray *activityAndMetting;
@end

@implementation SHActivityViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 1;
}

- (void)configView{
    [super configView];
    
    self.isOpenHeaderRefresh = YES;
    self.isOpenFooterRefresh = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityTableViewCell"];
    [self.tableView.mj_header beginRefreshing];
}

- (void)intoActivityDetail{
    SHActivityDetailViewController *vc = [[SHActivityDetailViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (NSMutableArray *)activityAndMetting{
    if (!_activityAndMetting) {
        _activityAndMetting = [NSMutableArray array];
    }
    return _activityAndMetting;
}


- (void)headerRefresh{
    [self loadActivityMeeting:nil isRefresh:YES];
}

- (void)footerRefresh{
    [self loadActivityMeeting:nil isRefresh:NO];
}

#pragma mark - API request

- (void)loadActivityMeeting:(NSString *)type isRefresh:(BOOL)isRefresh{
    if (isRefresh) {
        self.index = 1;
    }else{
        self.index++;
    }
    
    @weakify(self);
    [APIServerSdk doGetActivityMeeting:self.index type:type succeed:^(id obj) {
        @strongify(self);
        if (isRefresh) {
            [self.activityAndMetting removeAllObjects];
        }
        CommonResponseModel *model = obj;
        NSMutableArray *appendArray = [MettingModel mj_objectArrayWithKeyValuesArray: model.data];
        [self.activityAndMetting addObjectsFromArray:appendArray];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.index == model.page.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
    } needCache:NO cacheSucceed:nil failed:^(NSString *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!isRefresh) {
            self.index--;
        }
    }];
}

#pragma mark - Private methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activityAndMetting.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"ActivityTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityTableViewCell" forIndexPath:indexPath];
    MettingModel *model = self.activityAndMetting[indexPath.row];
    [cell setCellData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self intoActivityDetail];
}

@end
