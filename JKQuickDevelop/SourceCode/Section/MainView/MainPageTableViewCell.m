//
//  MainPageTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MainPageTableViewCell.h"
#import <ZYCornerRadius/UIImageView+CornerRadius.h>

@implementation MainPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageIcon.layer.cornerRadius = 5;
    self.imageIcon.layer.masksToBounds = YES;
}


@end
