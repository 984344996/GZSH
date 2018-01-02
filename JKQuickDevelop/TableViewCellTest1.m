//
//  TableViewCellTest1.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "TableViewCellTest1.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TableViewCellTest1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.desc];
        [self configConstraints];
    }
    return self;
}

- (UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc] init];
    }
    return _name;
}

- (UILabel *)desc{
    if (!_desc) {
        _desc = [[UILabel alloc] init];
    }
    return _desc;
}

- (UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatar;
}

- (void)configData:(NSDictionary *)dic{
    self.name.text = dic[@"name"];
    self.desc.text = dic[@"name"];
    self.avatar.image = [UIImage imageNamed:dic[@"avatar"]];
}

- (void)configConstraints{
    CGFloat padding = 20;
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(self.contentView).offset(padding);    // 设置titleLabel上边跟左边与父控件的偏移量
        make.right.mas_equalTo(self.contentView.mas_right).offset(-padding); // 设置titleLabel右边与父控件的偏移量
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left);                        // 设置contentImageView的左边对于titleLabel的左边对齐
        make.top.mas_equalTo(self.name.mas_bottom).offset(padding);   // 设置contentImageView的上边对于contentLabel的下面的偏移量
    }];
    
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left);                        // 设置userLabel的左边对于titleLabel的左边对齐
        make.top.mas_equalTo(self.avatar.mas_bottom).offset(padding); // 设置userLabel的上边对于contentImageView的下边的偏移量
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-padding); // 设置userLabel的下边对于父控件的下面的偏移量
    }];
}

@end
