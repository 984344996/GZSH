//
//  SHContactTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/11.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHContactTableViewCell.h"

@implementation SHContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellData:(NSDictionary *)dic{
    self.labelTitle.text = dic[@"title"];
    self.labelContent.text = dic[@"content"];
}

@end
