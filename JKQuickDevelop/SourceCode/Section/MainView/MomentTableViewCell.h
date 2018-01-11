//
//  MomentTableViewCell.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/7.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
#import "Comment.h"
#import "MomentUser.h"
#import "CommentTableViewCell.h"


@class MomentTableViewCell;

@protocol MomentCellDelegate <NSObject>

// 重新加载高度
- (void)reloadCellHeightForModel:(Moment *)model atIndexPath:(NSIndexPath *)indexPath;

// 点击评论时
- (void)passCellHeight:(CGFloat)cellHeight indexPath:(NSIndexPath *)indexPath commentModel:(Comment *)commentModel commentCell:(CommentTableViewCell *)cell momentCell:(MomentTableViewCell *)momentCell;

// 评论点击
- (void)btnCommentTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath;

// 喜欢
- (void)btnLikeTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath;

// 显示更多文字
- (void)btnMoreTextTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath;

// 九宫格图片点击
- (void)jggViewTapped:(NSUInteger)index dataource:(NSArray *)datasource;

// 点击头像
- (void)labelNameTapped:(MomentUser *)user;

@end

@interface MomentTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MomentCellDelegate> delegate;
@property (nonatomic, strong) Moment *moment;
- (void)configCellWithModel:(Moment *)model indexPath:(NSIndexPath *)indexPath;
@end
