//
//  MZIMTableViewController.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/22.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMTableViewController.h"
#import <MJRefresh.h>

#define kMZIMMessageTableViewCellIdentfier @"kMZIMMessageTableViewCellIdentfier"

@interface MZIMTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MZIMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self addRefreshHeader];
    
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MZIMMessageTableViewCell class] forCellReuseIdentifier:kMZIMMessageTableViewCellIdentfier];
        
        UIEdgeInsets insets = _tableView.contentInset;
        insets.bottom = 20;
        _tableView.contentInset = insets;
    }
    return _tableView;
}

- (void)addRefreshHeader{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMore:)];
    [header.lastUpdatedTimeLabel setHidden:YES];
    header.automaticallyChangeAlpha = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    [header setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [header setTitle:@"加载历史" forState:MJRefreshStatePulling];
    [header setTitle:@"加载历史" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"加载历史" forState:MJRefreshStateIdle];
    self.tableView.mj_header = header;
}

#pragma mark - Public methods
- (void)endRefreshing{
   [self.tableView.mj_header endRefreshing];
}

- (void)refreshMessages:(NSArray *)messages scrollToBottom:(BOOL)scrollToBottom animated:(BOOL)animated{
    self.messages = messages;
    BOOL isMessageAtBottom = [self checkIfTableAtBottom];
    
    [self.tableView reloadData];
    if (scrollToBottom || isMessageAtBottom) {
        //[self.tableView scrollToBottom:animated];
        return;
    }
}

#pragma mark - Private methods
- (BOOL)checkIfTableAtBottom{
    if (self.tableView.contentOffset.y + self.tableView.jk_height >= self.tableView.contentSize.height + self.tableView.contentInset.bottom) {
        return YES;
    }
    return NO;
}

- (void)checkAndExcuteKeyBoardSel:(BOOL)open{
    if ([self.delegate respondsToSelector:@selector(openOrCloseKeyBoard:)]) {
        [self.delegate openOrCloseKeyBoard:open];
    }
}

- (void)loadMore:(id) sender{
    [self.delegate loadMore];
}

#pragma mark - Delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGSize contentSize = scrollView.contentSize;
    CGPoint offset = scrollView.contentOffset;
    
    if (contentSize.height + scrollView.contentInset.bottom < scrollView.frame.size.height + offset.y){
        if (offset.y > self.lastOffset.y + 30) {
            ///开键盘
            [self checkAndExcuteKeyBoardSel:YES];
        }else{
            ///关键盘
            [self checkAndExcuteKeyBoardSel:NO];
        }
        return;
    }else{
        [self checkAndExcuteKeyBoardSel:NO];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastOffset = scrollView.contentOffset;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MZIMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMZIMMessageTableViewCellIdentfier forIndexPath:indexPath];
    [cell configureCellWithMessage:[self.messages objectAtIndex:indexPath.row] displayTimestamp:false];
    cell.messageTappedDelegate = self.delegate;
    if ([self.delegate respondsToSelector:@selector(tableViewLoadCell:)]) {
        [self.delegate tableViewLoadCell:cell];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [MZIMMessageTableViewCell getCellHeightByMessage:[self.messages objectAtIndex:indexPath.row] displayTimestamp:false];
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end
