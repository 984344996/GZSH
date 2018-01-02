//
//  TableViewCellTest2.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "TableViewCellTest2.h"

@implementation TableViewCellTest2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configData:(NSDictionary *)dic{
    self.name.text = dic[@"name"];
    self.avatar.image = [UIImage imageNamed:dic[@"avatar"]];
}

@end
