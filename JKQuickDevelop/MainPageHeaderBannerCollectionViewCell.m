//
//  MainPageHeaderBannerCollectionViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MainPageHeaderBannerCollectionViewCell.h"
#import <JKCategories.h>

@interface MainPageHeaderBannerCollectionViewCell()

@property (nonatomic, strong) UIImageView *iconLeft;
@property (nonatomic, strong) UIImageView *iconTop;
@property (nonatomic, strong) UILabel *labelDesc;
@property (nonatomic, strong) UILabel *labelDate;

@end

@implementation MainPageHeaderBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview: self.iconLeft];
    [self.contentView addSubview: self.iconTop];
    [self.contentView addSubview: self.labelDate];
    [self.contentView addSubview: self.labelDesc];
}

#pragma mark - Lazy loading

- (UIImageView *)iconLeft{
    if (!_iconLeft) {
        _iconLeft = [[UIImageView alloc] init];
    }
    return _iconLeft;
}

- (UIImageView *)iconTop{
    if (!_iconTop) {
        _iconTop = [[UIImageView alloc] init];
        _iconTop.image = [UIImage imageNamed:@"Home_Pic_NewTitle"];
    }
    return _iconTop;
}

- (UILabel *)labelDate{
    if (!_labelDate) {
        _labelDate = [[UILabel alloc] init];
        _labelDate.font = kMainTextFieldTextFontSmall;
        _labelDate.textColor = RGB(31, 77, 252);
    }
    return _labelDate;
}

- (UILabel *)labelDesc{
    if (!_labelDesc) {
        _labelDesc = [[UILabel alloc] init];
        _labelDesc.font = kMainTextFieldTextFontSmall;
        _labelDesc.textColor = kMainTextColor;
    }
    return _labelDesc;
}

- (void)setCellData:(NewsModel *)model{
    self.iconLeft.image = [UIImage imageNamed:@"Home_Icon_Activity"];
    self.labelDate.text = @"[11月17日]";
    self.labelDesc.text = model.title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.jk_width;
    
    [self.iconLeft setFrame:CGRectMake(12, 16, 48, 48)];
    [self.iconTop setFrame:CGRectMake(72, 6, 56, 20)];
    [self.labelDate setFrame:CGRectMake(w - 100, 8, 100, 17)];
    [self.labelDesc setFrame:CGRectMake(72, 26, w - 84, 35)];
}

@end
