//
//  MySupplyAndDemandTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/11.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MySupplyAndDemandTableViewCell.h"

@implementation MySupplyAndDemandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageIcon.layer.cornerRadius = 4;
    self.imageIcon.layer.masksToBounds = YES;
}


@end
