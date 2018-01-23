//
//  JKBaseTableViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKBaseViewController.h"
#import <MJRefresh.h>
#import <UIScrollView+EmptyDataSet.h>

@interface JKBaseTableViewController :JKBaseViewController<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITableViewDataSource,UITableViewDelegate>
// 列表
@property (nonatomic, strong) UITableView *tableView;

// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

// 开启头部刷新
@property (nonatomic, assign) BOOL isOpenHeaderRefresh;

// 开启加载更多
@property (nonatomic, assign) BOOL isOpenFooterRefresh;

/**
 展示空白控件
 */
- (BOOL)showEmptyView;

/**
 子类重写下拉加载调用
 */
- (void)headerRefresh;

/**
 子类重写上拉加载调用
 */
- (void)footerRefresh;

#pragma mark - UITable为空配置属性
/**
 数据源为空时显示Image
 
 @return Image
 */
- (UIImage *)emptyImage;

/**
 数据源为空时显示Title

 @return Title
 */
- (NSString *)emptyTitle;

/**
 数据源为空时显示描述

 @return 描述
 */
- (NSString *)emptyDescription;


/**
 数据源为空时按钮Title
 
 @return 按钮Title
 */
- (NSString *)emptyButtonTitle;
@end
