//
//  JKBaseTableViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKBaseTableViewController.h"
#import "NSString+Commen.h"

@interface JKBaseTableViewController ()

@end

@implementation JKBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    [self.view addSubview:self.tableView];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.jk_width, self.view.jk_height) style:UITableViewStylePlain];
        if ([self showEmptyView]) {
            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (BOOL)showEmptyView{
    return NO;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.tableView setFrame:self.view.bounds];
}

#pragma mark - 注册是否开启头部刷新and脚部刷新
- (void)setIsOpenHeaderRefresh:(BOOL)isOpenHeaderRefresh
{ _isOpenHeaderRefresh =  isOpenHeaderRefresh;
    if (_isOpenHeaderRefresh) {
        WEAKSELF
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }else{
        self.tableView.mj_header = nil;
    }
}

- (void)setIsOpenFooterRefresh:(BOOL)isOpenFooterRefresh
{  _isOpenFooterRefresh =  isOpenFooterRefresh;
    if (_isOpenFooterRefresh) {
        WEAKSELF
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefresh];
        }];
    }else{
        self.tableView.mj_footer = nil;
    }
}

// 重写接收头部刷新事件
- (void)headerRefresh{
    
}

// 重写接收头部加载事件
- (void)footerRefresh{
    
}

#pragma mark - Delegate
//IOS8 解决左边线间距问题
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableViewCellHeight;
}


#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据-%02ld",(long)indexPath.row];
    return cell;
}

#pragma mark - 没有数据时显示配置(不同的TableViewController需要重写)
-(UIImage *)emptyImage{
    return nil;
}
-(NSString *)emptyTitle{
    return nil;
}
-(NSString *)emptyDescription{
    return nil;
}
-(NSString *)emptyButtonTitle{
    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [self emptyImage];
}

#pragma mark - 没有数据时显示代理（不需要重写）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    if (![self emptyTitle]) {
        return nil;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:[self emptyTitle] attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    if (![self emptyDescription]) {
        return nil;
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:[self emptyDescription] attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    if (![self emptyButtonTitle]){
        return nil;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]}];
    if (state == UIControlStateNormal) {
        [attributes setObject:kBlueColor forKey:NSForegroundColorAttributeName];
    }else{
        [attributes setObject:kLightGrayColor forKey:NSForegroundColorAttributeName];
    }
    return [[NSAttributedString alloc] initWithString:[self emptyButtonTitle] attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIColor whiteColor];
}

@end
