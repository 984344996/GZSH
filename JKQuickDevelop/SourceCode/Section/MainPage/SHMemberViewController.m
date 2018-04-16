//
//  SHMemberViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHMemberViewController.h"
#import "MemberCenterTableViewCell.h"
#import "MemberCenterTableViewHeaderView.h"
#import "MyCompanyInfoViewController.h"
#import "MySupplyAndDemandViewController.h"
#import "ContactSHViewController.h"
#import "SHSettingViewController.h"
#import "UserInfo.h"
#import "APIServerSdk.h"
#import "AppDataFlowHelper.h"
#import <MJExtension.h>
#import <ReactiveObjC.h>

@interface SHMemberViewController ()

@property (nonatomic, strong) NSArray *cellModes;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) MemberCenterTableViewHeaderView *header;
@end

@implementation SHMemberViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.tableView.tableHeaderView = self.header;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MemberCenterTableViewCell"];
}

- (void)configData{
    [super configData];
    [self loadSelfUserInfo];
}

- (void)configEvent{
    [super configEvent];
    [self.header.vipView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *gen = [[UITapGestureRecognizer alloc] init];
    [self.header.vipView addGestureRecognizer:gen];
    [[gen rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
       
    }];
}

- (MemberCenterTableViewHeaderView *)header{
    if (!_header) {
        _header = [[MemberCenterTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, 99)];
    }
    return _header;
}

- (NSArray *)cellModes{
    if (!_cellModes) {
        _cellModes = [NSArray arrayWithObjects:@[@"VipCenter_Icon_Company",@"我的企业信息",@"intoMyCompanyInfo"],
                      @[@"VipCenter_Icon_AffordRequire",@"我的供求信息",@"intoMyApplyInfo"],
                      @[@"VipCenter_Icon_Contact",@"联系商会",@"intoSH"],
                      @[@"VipCenter_Icon_Set",@"设置",@"intoSetting"],
                      nil];
    }
    return _cellModes;
}

#pragma mark - APIServer

- (void)loadSelfUserInfo{
    NSString *userId = [AppDataFlowHelper getLoginUserInfo].userId;
    WEAKSELF
    [APIServerSdk doGetUserInfo:userId needCache:YES cacheSucceed:^(id obj) {
        STRONGSELF
        strongSelf.userInfo = [UserInfo mj_objectWithKeyValues:obj];

        UserInfo *saveInfo  = [UserInfo mj_objectWithKeyValues:obj];
        [AppDataFlowHelper saveLoginUserInfo:saveInfo];
    } succeed:^(id obj) {
        STRONGSELF
        strongSelf.userInfo = [UserInfo mj_objectWithKeyValues:obj];
    } failed:^(NSString *error) {
    }];
}


#pragma mark - Private methods

- (void)setUserInfo:(UserInfo *)userInfo{
    if (!userInfo) {
        return;
    }
    _userInfo = userInfo;
    [self.header setUserInfo:userInfo];
}

- (void)intoMyCompanyInfo{
    if (!self.hasAccessPermisson) {
        [self showNoAccessPermissionDialog];
        return;
    }
    MyCompanyInfoViewController *vc = [[MyCompanyInfoViewController alloc] initWithEnterpriseModel:nil isSelf:YES];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)intoMyApplyInfo{
    if (!self.hasAccessPermisson) {
        [self showNoAccessPermissionDialog];
        return;
    }
    MySupplyAndDemandViewController *vc = [[MySupplyAndDemandViewController alloc] initWithUserId:nil isSelf:YES];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)intoSH{
    ContactSHViewController *vc = [[ContactSHViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)intoSetting{
    SHSettingViewController *vc = [[SHSettingViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellModes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCenterTableViewCell" forIndexPath:indexPath];
    NSArray *mode                   = self.cellModes[indexPath.row];
    cell.imageIcon.image            = [UIImage imageNamed:mode[0]];
    cell.labelTitle.text            = mode[1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *mode         = self.cellModes[indexPath.row];
    SEL sel               = NSSelectorFromString(mode[2]);
    void (*func)(id, SEL) = (void *)[self methodForSelector:sel];
    func(self, sel);
}

@end
