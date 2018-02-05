//
//  MomentNewsViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MomentNewsViewController.h"
#import "MomentNewsTableViewCell.h"
#import "DynamicMsg+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>
#import "SHCircleViewController.h"
#import "AppUtils.h"

@interface MomentNewsViewController ()
@property (nonatomic, strong) NSMutableArray *newsModels;
@end

@implementation MomentNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    
    self.title = @"消息";
    [self addUIBarButtonItemText:@"清空" isLeft:NO target:self action:@selector(clearAll:)];
    self.tableView.separatorColor = kGrayLineColor;
    [self.tableView registerClass:[MomentNewsTableViewCell class] forCellReuseIdentifier:@"MomentNewsTableViewCell"];
}

- (void)configData{
    [super configData];
    [self refreshData];
}

- (void)refreshData{
    NSArray *array = [DynamicMsg MR_findAllSortedBy:@"createTime" ascending:NO];
    if (array) {
        [self.newsModels removeAllObjects];
        [self.newsModels addObjectsFromArray:array];
    }
    [self.tableView reloadData];
}

- (NSMutableArray *)newsModels{
    if (!_newsModels) {
        _newsModels = [[NSMutableArray alloc] init];
    }
    return _newsModels;
}

#pragma mark - Private methods

- (void)clearAll:(UIBarButtonItem *)sender{
    [self.newsModels removeAllObjects];
    [DynamicMsg MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [AppUtils fetchDynamicMsgCount];
    }];
    [self.tableView reloadData];
}

#pragma mark - Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MomentNewsTableViewCell" forIndexPath:indexPath];
    DynamicMsg *model        = self.newsModels[indexPath.row];
    [cell setNewsModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DynamicMsg *model = self.newsModels[indexPath.row];
    if (model.cellHeight > 0.1) {
        return model.cellHeight;
    }
    CGFloat h              = [MomentNewsTableViewCell heightWithMode:model];
    model.cellHeight       = h;
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicMsg *model = self.newsModels[indexPath.row];
    SHCircleViewController *vc = [[SHCircleViewController alloc] initWithMainPage:NO userid:nil];
    vc.momentId = model.dynamicId;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

@end
