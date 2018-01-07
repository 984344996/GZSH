//
//  ActivityTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ActivityTableViewCell.h"
#include "CornerTriangleView.h"

@interface ActivityTableViewCell()
@property (nonatomic, strong) CornerTriangleView *triangleView;
@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.triangleView];
    [self setUILayer:NO];
}

- (CornerTriangleView *)triangleView{
    if (!_triangleView) {
        CGRect tFrame = CGRectMake(0, 10, 70, 70);
        _triangleView = [[CornerTriangleView alloc] initWithFrame:tFrame andTitle:@"未开始" andTitleFont:kMainTextFieldTextFontBold12 andTitleColor:kWhiteColor andTriangleColor:kMainGreenColor];
    }
    return _triangleView;
}

#pragma mark - Private methods

- (void)setUILayer:(BOOL)outOfDate{
    if (outOfDate) {
        self.activityName.textColor = kSecondTextColor;
        self.activityAddress.textColor = kSecondTextColor;
        self.activityTime.textColor = kSecondTextColor;
        self.activityMemberCount.hidden = YES;
        [self.triangleView setTriangleColor:RGB(165, 168, 165)];
        [self.triangleView setTitle:@"已结束"];
    }else{
        self.activityName.textColor = kMainGreenColor;
        self.activityAddress.textColor = kMainTextColor;
        self.activityTime.textColor = kSecondTextColor;
        self.activityMemberCount.hidden = NO;
        [self.triangleView setTriangleColor:kMainGreenColor];
        [self.triangleView setTitle:@"未开始"];
    }
}

@end
