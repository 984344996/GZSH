//
//  MyCompanyInfoViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MyCompanyInfoViewController.h"
#import "MineCompanyTextTableViewCell.h"
#import "EnterpriseModel.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "NSString+Commen.h"
#import <MJExtension.h>
#import "MyCompanyInfoEditViewController.h"

@interface MyCompanyInfoViewController ()
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation MyCompanyInfoViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.title = @"我的企业信息";
    [self addUIBarButtonItemText:@"编辑" isLeft:NO target:self action:@selector(editInfo:)];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineCompanyTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineCompanyTextTableViewCell"];
}

- (void)configData{
    [super configData];
    EnterpriseModel *mode = [[EnterpriseModel alloc] init];
    mode.desc = @"详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本";
    mode.service = @"详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本详细文本";
    mode.mobile = @"18384345235";
    mode.email = @"18384345235@163.com";
    mode.address = @"川省成都市天府三街23432号";
    [self makeEnterpriseInfoToModel:mode];
}

- (void)makeEnterpriseInfoToModel:(EnterpriseModel *)model{
    if (![NSString isEmpty:model.desc]) {
        [self addItem:@"企业概况：" content:model.desc];
    }
    if (![NSString isEmpty:model.service]) {
        [self addItem:@"企业服务：" content:model.service];
    }
    if (![NSString isEmpty:model.mobile]) {
         [self addItem:@"电话号码：" content:model.mobile];
    }
    if (![NSString isEmpty:model.phone]) {
        [self addItem:@"座机：" content:model.phone];
    }
    if (![NSString isEmpty:model.email]) {
         [self addItem:@"邮件：" content:model.email];
    }
    if (![NSString isEmpty:model.address]) {
        [self addItem:@"邮件：" content:model.address];
    }
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

#pragma mark - Private methods

- (void)addItem:(NSString *)title content:(NSString *)content{
    [self.models addObject:@{
                             @"title":title,
                             @"content":content
                             }];
}

- (void)editInfo:(UIBarButtonItem *)sender{
    MyCompanyInfoEditViewController *vc = [[MyCompanyInfoEditViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:@"MineCompanyTextTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        MineCompanyTextTableViewCell *c = (MineCompanyTextTableViewCell *)cell;
        [c setCellData:self.models[indexPath.row]];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCompanyTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCompanyTextTableViewCell" forIndexPath:indexPath];
    [cell setCellData:self.models[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
