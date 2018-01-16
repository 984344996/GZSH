//
//  MomentNewsTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/13.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MomentNewsTableViewCell.h"
#import <YYText.h>
#import "MomentMacro.h"
#import <Masonry.h>
#import "NSString+Commen.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MomentNewsTableViewCell()
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) YYLabel *labelCommentText;
@property (nonatomic, strong) UILabel *labelMomentText;
@property (nonatomic, strong) UIImageView *imgContent;

@end

@implementation MomentNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commontInit];
    }
    return self;
}

- (void)commontInit{
    [self.contentView addSubview:self.labelName];
    [self.contentView addSubview:self.labelTime];
    [self.contentView addSubview:self.labelCommentText];
    [self.contentView addSubview:self.labelMomentText];
    [self.contentView addSubview:self.imgContent];
    
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12);
        make.top.equalTo(self.contentView).with.offset(7);
    }];
    
    [self.labelMomentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-12);
        make.top.equalTo(self.contentView).with.offset(7);
        make.width.mas_equalTo(75);
    }];
    
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelName.mas_right).with.offset(8);
        make.centerY.equalTo(self.labelName);
        make.right.lessThanOrEqualTo(self.labelMomentText.mas_left);
    }];
    
    [self.labelCommentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12);
        make.top.equalTo(self.labelName.mas_bottom).with.offset(3);
        make.right.equalTo(self.labelMomentText.mas_left).with.offset(-20);
    }];
    
    [self.imgContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-12);
        make.top.equalTo(self.contentView).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
}

- (void)setNewsModel:(MomentNewsModel *)newsModel{
    _newsModel = newsModel;
    if ([NSString isEmpty:newsModel.imgUrl]) {
        [self.imageView setHidden:YES];
        [self.labelMomentText setHidden:NO];
    }else{
        [self.imageView setHidden:NO];
        [self.labelMomentText setHidden:YES];
        [self.imgContent sd_setImageWithURL:[NSURL URLWithString:newsModel.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    self.labelName.text = newsModel.username;
    self.labelTime.text = newsModel.time;
    self.labelCommentText.text = newsModel.content;
    self.labelMomentText.text = newsModel.contentToBeComment;
}

+ (CGFloat)heightWithMode:(MomentNewsModel *)newsModel{
    
    CGFloat hAppendLeft = [newsModel.content textSizeIn:CGSizeMake(JK_SCREEN_WIDTH - 121.0, CGFLOAT_MAX) font:kMainTextFieldTextFontSmall].height;
    
    CGFloat hRight;
    if ([NSString isEmpty:newsModel.imgUrl]) {
        hRight = [newsModel.contentToBeComment textSizeIn:CGSizeMake(75, CGFLOAT_MAX) font:kMainTextFieldTextFontSmall].height + 12;
    }else{
        hRight = 66;
    }
    
    return MAX(35 + hAppendLeft,hRight);
}

#pragma mark - Lazy loading

- (UILabel *)labelName{
    if (!_labelName) {
        _labelName = [[UILabel alloc] init];
        _labelName.font = kMainTextFieldTextFontBold12;
        _labelName.textColor = kMomentHightTextColor;
    }
    return _labelName;
}

- (UILabel *)labelTime{
    if (!_labelTime) {
        _labelTime = [[UILabel alloc] init];
        _labelTime.font = [UIFont systemFontOfSize:10];
        _labelTime.textColor = kSecondTextColor;
    }
    return _labelTime;
}

- (YYLabel *)labelCommentText{
    if (!_labelCommentText) {
        _labelCommentText = [[YYLabel alloc] init];
        _labelCommentText.font = kMainTextFieldTextFontSmall;
        _labelCommentText.textColor = kMomentHightTextColor;
        _labelCommentText.preferredMaxLayoutWidth = JK_SCREEN_WIDTH - 121;
        _labelCommentText.numberOfLines = 0;
    }
    return _labelCommentText;
}

- (UILabel *)labelMomentText{
    if (!_labelMomentText) {
        _labelMomentText = [[UILabel alloc] init];
        _labelMomentText.font = kMainTextFieldTextFontSmall;
        _labelMomentText.textColor = kMainTextColor;
        _labelMomentText.numberOfLines = 0;
    }
    return _labelMomentText;
}

- (UIImageView *)imgContent{
    if (!_imgContent) {
        _imgContent = [[UIImageView alloc] init];
        _imgContent.contentMode = UIViewContentModeScaleAspectFill;
        _imgContent.layer.masksToBounds = YES;
    }
    return _imgContent;
}

@end
