//
//  MySupplyAndDemandTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/11.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MySupplyAndDemandTableViewCell.h"
#import "NSDate+Common.h"
#import <UIImageView+WebCache.h>

@implementation MySupplyAndDemandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageIcon.contentMode        = UIViewContentModeScaleAspectFill;
    self.imageIcon.layer.cornerRadius = 4;
    self.imageIcon.layer.masksToBounds = YES;
}

- (void)setCellData:(DemandInfo *)model{
    self.labelTitle.text = model.title;
    self.labelTime.text = [NSDate parseServerDateTimeToFormat:model.time format:kTurnState1];
    [self.imageIcon sd_setImageWithURL:GetImageUrl(model.imgUrl) placeholderImage:kPlaceHoderBannerImage];
}
@end
