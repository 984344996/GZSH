//
//  TableViewCellTest1.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellTest1 : UITableViewCell

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UIImageView *avatar;

- (void)configData:(NSDictionary *)dic;

@end
