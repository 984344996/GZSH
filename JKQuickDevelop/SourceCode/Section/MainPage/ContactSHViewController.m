//
//  ContactSHViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ContactSHViewController.h"
#import <JKCategories.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import "SHContactTableViewCell.h"

@implementation ContactSHHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"SignUp_Logo"];
    }
    return _imageView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_imageView setJk_centerX:self.jk_centerX];
    [_imageView setJk_top:61];
}

@end

@interface ContactSHViewController ()
@property (nonatomic, strong) NSArray *dataDics;
@property (nonatomic, strong) ContactSHHeaderView *header;
@end

@implementation ContactSHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.title = @"联系商会";
    self.tableView.tableHeaderView = self.header;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SHContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"SHContactTableViewCell"];
}

- (ContactSHHeaderView *)header{
    if (!_header) {
        _header = [[ContactSHHeaderView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, 225)];
    }
    return _header;
}

- (NSArray *)dataDics{
    if (!_dataDics) {
        _dataDics = [NSArray arrayWithObjects:
                     @{@"title":@"座机：",@"content":@"028-34523423"},
                     @{@"title":@"传真：",@"content":@"028-34523423"},
                     @{@"title":@"微信号：",@"content":@"gzsh360"},
                     @{@"title":@"邮：",@"content":@"gzsh@163.com"},
                     @{@"title":@"地址：",@"content":@"成都市高新区孵化园A座109号"},nil];
    }
    return _dataDics;
}
#pragma mark - Private methods


#pragma mark - Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataDics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SHContactTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SHContactTableViewCell" forIndexPath:indexPath];
    [cell setCellData:self.dataDics[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:@"SHContactTableViewCell" configuration:^(id cell) {
        SHContactTableViewCell *c = (SHContactTableViewCell *)cell;
        [c setCellData:self.dataDics[indexPath.row]];
    }];
}

@end
