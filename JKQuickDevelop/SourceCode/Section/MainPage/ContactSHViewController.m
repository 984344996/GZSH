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
#import "APIServerSdk.h"
#import "SysInfoModel.h"
#import <MJExtension.h>

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

- (void)configData{
    [super configData];
    [self loadSysInfo];
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
                     @{@"title":@"座机：",@"content":@" "},
                     @{@"title":@"传真：",@"content":@" "},
                     @{@"title":@"微信号：",@"content":@" "},
                     @{@"title":@"邮：",@"content":@" "},
                     @{@"title":@"地址：",@"content":@" "},nil];
    }
    return _dataDics;
}


#pragma mark - Private methods

- (void)loadSysInfo{
    WEAKSELF
    [APIServerSdk doGetSysInfo:^(id obj) {
        STRONGSELF
        SysInfoModel *model = [SysInfoModel mj_objectWithKeyValues:obj];
        [strongSelf refreshSysData:model];
    } failed:^(NSString *error) {
    }];
}

- (void)refreshSysData:(SysInfoModel *)model{
    _dataDics = [NSArray arrayWithObjects:
                 @{@"title":@"座机：",@"content":model.tel},
                 @{@"title":@"传真：",@"content":model.fax},
                 @{@"title":@"微信号：",@"content":model.wx},
                 @{@"title":@"邮箱：",@"content":model.email},
                 @{@"title":@"地址：",@"content":model.address},nil];
    [self.tableView reloadData];
}

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
