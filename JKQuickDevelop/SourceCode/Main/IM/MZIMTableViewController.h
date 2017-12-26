//
//  MZIMTableViewController.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/22.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZIMMessage.h"
#import "MZIMMessageTableViewCell.h"
#import <MJRefresh.h>

@protocol MZIMTableViewDelegate <MZIMMessageTappedDelegate>

@optional
- (void)openOrCloseKeyBoard:(BOOL)open;
- (void)tableViewLoadCell:(MZIMMessageTableViewCell*)cell;

@required
/**
 加载更多
 */
- (void)loadMore;
@end

@interface MZIMTableViewController : UIViewController

/**
 刷新完成调用 用于收回下拉刷新控件
 */
-(void)endRefreshing;

/**
 刷新消息 当接收到新消息的时候调用

 @param messages 待刷新的消息数组
 @param scrollToBottom 是否滚到列表底部
 @param animated 是否产生动画
 */
-(void)refreshMessages:(NSArray *)messages scrollToBottom:(BOOL)scrollToBottom animated:(BOOL)animated;

@property (nonatomic, weak) id<MZIMTableViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;

/**
 缓存的消息数组 由外部设置
 */
@property (nonatomic, strong) NSArray *messages;

/**
 UITableView上次的offset
 */
@property (nonatomic, assign) CGPoint lastOffset;
@end
