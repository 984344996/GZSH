//
//  MomentNewsViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MomentNewsViewController.h"
#import "MomentNewsModel.h"
#import "MomentNewsTableViewCell.h"

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
    
    MomentNewsModel *test1 = [[MomentNewsModel alloc] init];
    test1.username = @"朋友A";
    test1.time = @"18分钟前";
    test1.content = @"风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~ 风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~";
    test1.imgUrl = @"http://weixintest.ihk.cn/ihkwx_upload/userPhoto/15914867203-1461920972642.jpg";
    
    MomentNewsModel *test2 = [[MomentNewsModel alloc] init];
    test2.username = @"摸摸摸摸摸";
    test2.time = @"一天前";
    test2.content = @"风景真美，什么时候去得~ 什么时候去得~风景真美，什么时候去得~";
    test2.contentToBeComment = @"风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~风景真美，什么时候去得~";
    
    [self.newsModels addObject:test1];
    [self.newsModels addObject:test2];
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
    [self.tableView reloadData];
}

#pragma mark - Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MomentNewsTableViewCell" forIndexPath:indexPath];
    MomentNewsModel *model        = self.newsModels[indexPath.row];
    [cell setNewsModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentNewsModel *model = self.newsModels[indexPath.row];
    if (model.cellHeight > 0.1) {
        return model.cellHeight;
    }
    CGFloat h              = [MomentNewsTableViewCell heightWithMode:model];
    model.cellHeight       = h;
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
