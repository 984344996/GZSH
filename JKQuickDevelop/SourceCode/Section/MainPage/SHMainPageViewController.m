//
//  SHMainPageViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHMainPageViewController.h"
#import "MainPageTableHeaderView.h"
#import "MainPageTableViewCell.h"
#import "MainPageSectionView.h"
#import <JKCategories.h>

@interface SHMainPageViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MainPageTableHeaderView *header;

@end

@implementation SHMainPageViewController

- (void)configView{
    [super configView];
    self.tableView.tableHeaderView = self.header;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MainPageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainPageTableViewCell"];
}

#pragma mark - Lazy loading

- (MainPageTableHeaderView *)header{
    if (!_header) {
        _header = [[MainPageTableHeaderView alloc] init];
        [_header sizeToFit];
    }
    return _header;
}

#pragma mark - Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainPageTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MainPageSectionView *sectionView = [[MainPageSectionView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, 40)];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
