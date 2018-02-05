//
//  MomentHeaderView.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/8.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MomentHeaderView.h"
#import <Masonry.h>

@interface MomentHeaderView()
@property (nonatomic, strong) UIImageView *imageArrow;
@end

@implementation MomentHeaderView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self makeLayout];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.imagePosterView];
    [self addSubview:self.containerView];
    [self addSubview:self.imageAvtar];
    
    [self.containerView addSubview:self.labelCommentName];
    [self.containerView addSubview:self.labelCommentCount];
    [self.containerView addSubview:self.imageArrow];
}

- (void)makeLayout{
    [self.imagePosterView setFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, JK_SCREEN_WIDTH * 0.54)];
    
    [self.imageAvtar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12);
        make.size.mas_equalTo(CGSizeMake(82, 82));
        make.centerY.equalTo(self.imagePosterView.mas_bottom);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imagePosterView.mas_bottom).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(132, 40));
    }];
    
    [self.labelCommentName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.top.equalTo(self.containerView).with.offset(2);
        make.height.mas_equalTo(17);
    }];

    [self.labelCommentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).with.offset(10);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.bottom.equalTo(self.containerView).with.offset(-2);
        make.height.mas_equalTo(17);
    }];

    [self.imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView);
        make.right.equalTo(self.containerView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(6, 9));
    }];
}

- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(JK_SCREEN_WIDTH, JK_SCREEN_WIDTH * 0.54 + 44);
}
#pragma mark - Getter and Setter

- (UIImageView *)imagePosterView{
    if (!_imagePosterView) {
        _imagePosterView = [[UIImageView alloc] init];
        _imagePosterView.image = [UIImage imageNamed:@"Circle_Img_Top"];
        _imagePosterView.contentMode = UIViewContentModeScaleAspectFill;
        _imagePosterView.layer.masksToBounds = YES;
    }
    return _imagePosterView;
}

- (UIImageView *)imageAvtar{
    if (!_imageAvtar) {
        _imageAvtar                   = [[UIImageView alloc] init];
        _imageAvtar.contentMode       = UIViewContentModeScaleAspectFill;
        _imageAvtar.layer.borderWidth = 2;
        _imageAvtar.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageAvtar.layer.masksToBounds = YES;
        _imageAvtar.userInteractionEnabled = YES;
    }
    return _imageAvtar;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = RGB(54, 53, 53);
        _containerView.layer.cornerRadius = 4;
        _containerView.layer.masksToBounds = YES;
        _containerView.hidden = YES;
    }
    return _containerView;
}

- (UILabel *)labelCommentName{
    if (!_labelCommentName) {
        _labelCommentName = [[UILabel alloc] init];
        _labelCommentName.text = @"";
        _labelCommentName.textAlignment = NSTextAlignmentCenter;
        _labelCommentName.font = kMainTextFieldTextFontBold12;
        _labelCommentName.textColor = RGB(139, 165, 139);
        
    }
    return _labelCommentName;
}

- (UILabel *)labelCommentCount{
    if (!_labelCommentCount) {
        _labelCommentCount = [[UILabel alloc] init];
        _labelCommentCount.text = @"";
        _labelCommentCount.textAlignment = NSTextAlignmentCenter;
        _labelCommentCount.font = kMainTextFieldTextFontBold12;
        _labelCommentCount.textColor = RGB(185, 185, 187);
        
    }
    return _labelCommentCount;
}

- (UIImageView *)imageArrow{
    if (!_imageArrow) {
        _imageArrow = [[UIImageView alloc] init];
        _imageArrow.image = [UIImage imageNamed:@"Circle_Arrow_Right"];
    }
    return _imageArrow;
}

@end
