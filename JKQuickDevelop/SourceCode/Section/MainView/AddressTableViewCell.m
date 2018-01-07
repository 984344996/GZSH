//
//  AddressTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupCellData:(Contact *)data{
    self.labelName.text = data.userName;
    self.labelPhone.text = data.mobile;
    self.labelCompany.text = data.enterprise;
}

@end
