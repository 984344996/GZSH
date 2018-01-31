//
//  LikeTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/7.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "LikeTableViewCell.h"
#import <YYText.h>
#import <Masonry.h>
#import "MomentMacro.h"
#import <JKCategories.h>

@interface LikeTableViewCell()
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSMutableArray *likeUserArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@end

@implementation LikeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.bottomLine];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(8);
        make.right.with.offset(-8);
        make.top.equalTo(self.contentView).with.offset(3.0);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    self.backgroundColor = [UIColor clearColor];
    self.hyb_lastViewInCell = self.contentLabel;
    self.hyb_bottomOffsetToCell = 0;
}

- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.font = kCommentFont;
        _contentLabel.preferredMaxLayoutWidth = kMomentCommentWidth;
    }
    return _contentLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = RGB(238, 236, 236);
    }
    return _bottomLine;
}

#pragma mark - Public methods

- (void)setMoment:(Moment *)moment{
    _moment = moment;
    _likeUserArray = moment.praiseList.mutableCopy;
    NSMutableAttributedString *mutablAttrStr = [[NSMutableAttributedString alloc]init];
    UIImage *image = [UIImage imageNamed:@"Circle_Icon_Like_BrightGreen"];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(24,24) alignToFont:kCommentFont alignment:YYTextVerticalAlignmentCenter
                                             ];
    [mutablAttrStr appendAttributedString:attachText];
    
    for (int i = 0; i < self.likeUserArray.count; i++) {
        MomentUser *user = self.likeUserArray[i];
        [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:user.name attributes:@{NSForegroundColorAttributeName : kMomentHightTextColor}]];
        if (i != self.likeUserArray.count - 1) {
            [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"，" attributes:@{NSForegroundColorAttributeName : kMomentHightTextColor}]];
        }
    }
    self.contentLabel.attributedText = mutablAttrStr;
}

@end
