//
//  MomentTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/7.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MomentTableViewCell.h"
#import "CopyAbleLabel.h"
#import "LikeTableViewCell.h"
#import "CommentTableViewCell.h"
#import <Masonry.h>
#import "MomentMacro.h"
#import "JGGView.h"
#import "DynamicInfo.h"
#import <UIImageView+WebCache.h>
#import "NSDate+Common.h"

@interface MomentTableViewCell()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CopyAbleLabel *descLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, strong) JGGView *jggView;
@end

@implementation MomentTableViewCell

#pragma mark - Lazy loading

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        self.nameLabel.preferredMaxLayoutWidth = JK_SCREEN_WIDTH - kGAP - kAvatar_Size - 2*kGAP-kGAP;
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = kMomentTitleFont;
        _nameLabel.textColor = kMomentTitleTextColor;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = kSecondTextColor;
    }
    return _timeLabel;
}

- (CopyAbleLabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [CopyAbleLabel new];
        _descLabel.preferredMaxLayoutWidth = JK_SCREEN_WIDTH - kGAP - kAvatar_Size ;
        _descLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _descLabel.numberOfLines = 0;
        _descLabel.font = kMomentDetailFont;
        _descLabel.textColor = kMomentDetailTextColor;
    }
    return _descLabel;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        [_moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _moreBtn.selected = NO;
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (JGGView *)jggView{
    if (!_jggView) {
        _jggView = [JGGView new];
        
    }
    return _jggView;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn                   = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_commentBtn setImage:[UIImage imageNamed:@"Circle_Icon_Comment_Dark"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn                   = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_likeBtn setImage:[UIImage imageNamed:@"Circle_Icon_Like_Dark"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"Circle_Icon_Like_BrightRed"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView                            = [[UITableView alloc] init];
        _tableView.scrollEnabled              = NO;
        [_tableView registerClass:NSClassFromString(@"CommentTableViewCell") forCellReuseIdentifier:@"CommentTableViewCell"];
        [_tableView registerClass:NSClassFromString(@"LikeTableViewCell") forCellReuseIdentifier:@"LikeTableViewCell"];
        _tableView.backgroundColor            = kMomentCommentBGTextColor;
        _tableView.separatorStyle             = UITableViewCellSeparatorStyleNone;
        self.tableView.userInteractionEnabled = YES;
        self.tableView.backgroundView.userInteractionEnabled = YES;
    }
    return _tableView;
}

#pragma mark - Events

- (void)commentAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(btnCommentTapped:indexPath:)]) {
        [self.delegate btnCommentTapped:sender indexPath:self.indexPath];
    }
}

- (void)likeAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(btnLikeTapped:indexPath:)]) {
        [self.delegate btnLikeTapped:sender indexPath:self.indexPath];
    }
}

- (void)moreAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(btnMoreTextTapped:indexPath:)]) {
        [self.delegate btnMoreTextTapped:sender indexPath:self.indexPath];
    }
}

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kGAP);
            make.width.height.mas_equalTo(kAvatar_Size);
        }];
        // nameLabel
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.headImageView);
            make.right.mas_equalTo(-kGAP);
        }];
        
        // desc
        [self.contentView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP/2.0);
        }];
        
        //全文
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
        
        
        [self.contentView addSubview:self.jggView];
        [self.jggView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.moreBtn);
            make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kGAP);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.jggView);
            make.top.mas_equalTo(self.jggView.mas_bottom).offset(2);
        }];
        
        [self.contentView addSubview:self.likeBtn];
        [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        
        [self.contentView addSubview:self.commentBtn];
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.likeBtn.mas_left);
            make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        
        [self.contentView addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.jggView);
            make.top.mas_equalTo(self.commentBtn.mas_bottom).offset(5);
            make.right.mas_equalTo(-kGAP);
        }];
        
        self.hyb_lastViewInCell = self.tableView;
        self.hyb_bottomOffsetToCell = kGAP;
    }
    return self;
}

#pragma mark - Public methods

- (void)configCellWithModel:(Moment *)model indexPath:(NSIndexPath *)indexPath {
    _moment = model;
    self.indexPath = indexPath;
    self.nameLabel.text = model.momentUser.name;
    [self.likeBtn setSelected: model.dynamicInfo.hasPraised];
    self.timeLabel.text = [NSDate getMomentDateStamp:model.dynamicInfo.createTime];
    
    [self.headImageView sd_setImageWithURL:GetImageUrl(model.momentUser.avatar) placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
    muStyle.lineSpacing = 3;//设置行间距离
    muStyle.alignment = NSTextAlignmentLeft;//对齐方式
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:model.text];
    [attrString addAttribute:NSFontAttributeName value:kMomentDetailFont range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, attrString.length)];
    self.descLabel.attributedText = attrString;
    self.descLabel.highlightedTextColor = [UIColor blackColor];
    self.descLabel.highlighted = YES; //高亮状态是否打开
    self.descLabel.enabled = YES;//设置文字内容是否可变
    self.descLabel.userInteractionEnabled = YES;//设置标签是否忽略或移除用户交互。默认为NO
    
    NSDictionary *attributes = @{NSFontAttributeName:kMomentDetailFont,NSParagraphStyleAttributeName:muStyle};
    CGFloat h = [model.text boundingRectWithSize:CGSizeMake(JK_SCREEN_WIDTH - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height + 0.5;
    if (h<=60) {
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }else{
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
    }
    
    if (model.isExpand) {//展开
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP/2.0);
            make.height.mas_equalTo(h);
        }];
    }else{//闭合
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP/2.0);
            make.height.mas_lessThanOrEqualTo(60);
        }];
    }
    
    self.moreBtn.selected = model.isExpand;
    CGFloat jgg_width = JK_SCREEN_WIDTH-2*kGAP-kAvatar_Size-50;
    CGFloat image_width = (jgg_width-2*kGAP)/3;
    CGFloat jgg_height = 0.0;
    
    if (model.content.count==0) {
        jgg_height = 0;
    }else if (model.content.count<=3) {
        jgg_height = image_width;
    }else if (model.content.count>3&&model.content.count<=6){
        jgg_height = 2*image_width+kGAP;
    }else  if (model.content.count>6&&model.content.count<=9){
        jgg_height = 3*image_width+2*kGAP;
    }
    
    ///解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.jggView.dataSource = model.content;
    WEAKSELF
    self.jggView.tapBlock = ^(NSInteger index, NSArray *dataSource) {
        STRONGSELF
        if ([strongSelf.delegate respondsToSelector:@selector(jggViewTapped:dataource:)]) {
            [strongSelf.delegate jggViewTapped:index dataource:dataSource];
        }
    };
    
    CGFloat jggMagin = kGAP/2;
    if (jgg_height < 0.1) {
        jggMagin = 0;
    }
    ///布局九宫格
    [self.jggView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreBtn);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(jggMagin);
        make.size.mas_equalTo(CGSizeMake(jgg_width, jgg_height));
    }];
    
    CGFloat tableViewHeight = 0;
    for (id obj in model.commentList) {
        if ([obj isKindOfClass:[NSArray class]]) {
        }else{
            Comment *commentModel = (Comment *)obj;
            CGFloat cellHeight = [CommentTableViewCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
                CommentTableViewCell *cell = (CommentTableViewCell *)sourceCell;
                [cell configCellWithModel:commentModel];
            } cache:^NSDictionary *{
                return @{kHYBCacheUniqueKey : commentModel.commentId,
                         kHYBCacheStateKey : @"",
                         kHYBRecalculateForStateKey : @(YES)};
            }];
            tableViewHeight += cellHeight;
        }
    }
    
    if (self.moment.praiseList.count > 0) {
        CGFloat cellLike = [LikeTableViewCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
            LikeTableViewCell *cell = (LikeTableViewCell *)sourceCell;
            [cell setMoment:self.moment];
        } cache:^NSDictionary *{
            return @{kHYBCacheUniqueKey : self.moment.dynamicInfo.dynamicId,
                     kHYBCacheStateKey : @"",
                     kHYBRecalculateForStateKey : @(YES)};
        }];
        tableViewHeight += cellLike;
    }
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}


#pragma mark - Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LikeTableViewCell *likeUsersCell = [tableView dequeueReusableCellWithIdentifier:@"LikeTableViewCell" forIndexPath:indexPath];
        [likeUsersCell setMoment:self.moment];
        return likeUsersCell;
    }
    CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    Comment *model = self.moment.commentList[indexPath.row];
    [commentCell configCellWithModel:model];
    return commentCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 ) {
        if (self.moment.praiseList.count) {
            return 1;
        }
        return 0;
    }
    return self.moment.commentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat cellHeight = [LikeTableViewCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
            LikeTableViewCell *cell = (LikeTableViewCell *)sourceCell;
            [cell setMoment:self.moment];
        } cache:^NSDictionary *{
            return @{kHYBCacheUniqueKey : self.moment.dynamicInfo.dynamicId,
                     kHYBCacheStateKey : @"",
                     kHYBRecalculateForStateKey : @(YES)};
        }];
        return cellHeight;
    }else{
        Comment *commentModel = self.moment.commentList[indexPath.row];
        CGFloat cellHeight = [CommentTableViewCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
            CommentTableViewCell *cell = (CommentTableViewCell *)sourceCell;
            [cell configCellWithModel:commentModel];
        } cache:^NSDictionary *{
            return @{kHYBCacheUniqueKey : commentModel.commentId,
                     kHYBCacheStateKey : @"",
                     kHYBRecalculateForStateKey : @(YES)};
        }];
        return cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        Comment *commentModel = self.moment.commentList[indexPath.row];
        CGFloat cellHeight = [CommentTableViewCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
            CommentTableViewCell *cell = (CommentTableViewCell *)sourceCell;
            [cell configCellWithModel:commentModel];
        } cache:^NSDictionary *{
            return @{kHYBCacheUniqueKey : commentModel.commentId,
                     kHYBCacheStateKey : @"",
                     kHYBRecalculateForStateKey : @(YES)};
        }];
        
        CommentTableViewCell *commentCell = (CommentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(passCellHeight:indexPath:commentModel:commentCell:momentCell:)]) {
            [self.delegate passCellHeight:cellHeight indexPath:self.indexPath commentModel:commentModel commentCell:commentCell momentCell:self];
        }
    }
}
@end
