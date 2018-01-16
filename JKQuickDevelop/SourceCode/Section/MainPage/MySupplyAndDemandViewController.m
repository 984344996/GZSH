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

@interface MySupplyAndDemandViewController ()
@property (nonatomic, strong) NSMutableArray *supplies;
@end

@implementation MySupplyAndDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.title = @"我的供求信息";
    [self addUIBarButtonItemText:@"发布" isLeft:NO target:self action:@selector(doPublish:)];
    
    self.tableView.separatorColor = kGrayLineColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"MySupplyAndDemandTableViewCell" bundle:nil] forCellReuseIdentifier:@"MySupplyAndDemandTableViewCell"];
}

#pragma mark - Private methods

- (void)doPublish:(UIBarButtonItem *)sender{
    MySupplyAndDemandEditViewController *vc = [[MySupplyAndDemandEditViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Table Delegate and Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MySupplyAndDemandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MySupplyAndDemandTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
