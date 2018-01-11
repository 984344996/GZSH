//
//  SHCircleViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHCircleViewController.h"
#import "MomentTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <Masonry.h>
#import "Moment.h"
#import <MJExtension.h>
#import "MomentMacro.h"
#import "MomentHeaderView.h"
#import <ZLPhotoActionSheet.h>

@interface SHCircleViewController ()<MomentCellDelegate>

@property (nonatomic, strong) NSMutableArray *momentModes;
@property (nonatomic, strong) MomentHeaderView *header;

@end

@implementation SHCircleViewController

- (void)configView{
    [super configView];
    
    self.tableView.tableHeaderView = self.header;
    [self.tableView registerClass:[MomentTableViewCell class] forCellReuseIdentifier:@"MomentTableViewCell"];
}

- (void)configData{
    [super configData];
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"moment" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"data"]) {
        [self.momentModes addObject:[Moment mj_objectWithKeyValues:eachDic]];
    }
    [self.tableView reloadData];
}

- (NSMutableArray *)momentModes{
    if (!_momentModes) {
        _momentModes = [[NSMutableArray alloc] init];
    }
    return _momentModes;
}


- (MomentHeaderView *)header{
    if (!_header) {
        _header = [[MomentHeaderView alloc] init];
        [_header sizeToFit];
    }
    return _header;
}

#pragma mark - Private methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.momentModes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MomentTableViewCell" forIndexPath:indexPath];
    Moment *model = self.momentModes[indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Moment *moment = self.momentModes[indexPath.row];
    CGFloat h = [MomentTableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        MomentTableViewCell *cell = (MomentTableViewCell *)sourceCell;
        [cell configCellWithModel:moment indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : moment.momentId,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(moment.shouldUpdateCache)};
        moment.shouldUpdateCache = NO;
        return cache;
    }];
    return h;
}

#pragma mark - MomentCell Delegate

// 重新加载高度
- (void)reloadCellHeightForModel:(Moment *)model atIndexPath:(NSIndexPath *)indexPath{
    
}

// 点击评论时
- (void)passCellHeight:(CGFloat)cellHeight indexPath:(NSIndexPath *)indexPath commentModel:(Comment *)commentModel commentCell:(CommentTableViewCell *)cell momentCell:(MomentTableViewCell *)momentCell{
    
}

// 评论点击
- (void)btnCommentTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    
}

// 喜欢
- (void)btnLikeTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    
}

// 显示更多文字
- (void)btnMoreTextTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    Moment *moment = self.momentModes[indexPath.row];
    moment.isExpand = !moment.isExpand;
    moment.shouldUpdateCache = YES;
    [self.tableView reloadData];
}

// 九宫格图片点击
- (void)jggViewTapped:(NSUInteger)index dataource:(NSArray *)datasource{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sender = self;
    actionSheet.navBarColor = kGreenColor;
    actionSheet.navTitleColor = kWhiteColor;
    NSMutableArray *urls = [NSMutableArray array];
    [datasource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:obj];
            [urls addObject:url];
        }
    }];
    [actionSheet previewPhotos:urls index:index hideToolBar:YES  complete:^(NSArray * _Nonnull photos) {
        
    }];
}

// 点击头像
- (void)labelNameTapped:(MomentUser *)user{
    
}

@end
