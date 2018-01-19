//
//  SHSettingViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHSettingViewController.h"
#import <JKCategories.h>
#import "ResetPasswordViewController.h"
#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "AppDataFlowHelper.h"
#import "LoginViewController.h"
#import <ReactiveObjC.h>
#import <LEEAlert.h>
#import "ResetPasswordViewController.h"

@interface SHSettingViewController ()
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) UIButton *btnLogout;
@end

@implementation SHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    self.title = @"设置";
    [super configView];
    [self.tableView setBackgroundColor:kMainBottomLayerColor];
    self.tableView.separatorColor = kGrayLineColor;
    [self.view addSubview:self.btnLogout];
}

- (void)configEvent{
    [super configEvent];
    
    @weakify(self)
    [[[self btnLogout] rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self alertLogout];
    }];
}

- (NSArray *)cellTitles{
    if (!_cellTitles) {
        _cellTitles = [[NSArray alloc] initWithObjects:@"修改密码",@"意见反馈", nil];
    }
    return _cellTitles;
}

- (UIButton *)btnLogout{
    if (!_btnLogout) {
        _btnLogout                 = [[UIButton alloc] init];
        _btnLogout.titleLabel.font = kMainTextFieldTextFontBold16;
        [_btnLogout setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_btnLogout jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
        [_btnLogout jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
        [_btnLogout setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    return _btnLogout;
}


#pragma mark - Private methods

- (void)alertLogout{
    [LEEAlert alert]
    .config
    .LeeTitle(@"提示")
    .LeeCancelAction(@"取消", ^{
        
    })
    .LeeAction(@"确定", ^{
        [AppDataFlowHelper loginOut];
        LoginViewController *vc = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [[AppDelegate sharedAppDelegate] replaceRootViewController:nav animated:YES];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = @"退出当前账户？";
        label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
        label.textAlignment = NSTextAlignmentCenter;
    })
    .LeeShow();
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat w = self.view.jk_width;
    CGFloat h = self.view.jk_height;
    
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += kDeltaForIphoneX;
    }
    [self.btnLogout setFrame:CGRectMake(0, h - btnH, w, btnH)];
}

#pragma mark - Private methods

- (void)intoChangePassword{
    ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] init];
    vc.pushedFromLogin = NO;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)intoFeedback{
    FeedbackViewController *vc = [[FeedbackViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Delefate and Datasource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.cellTitles[indexPath.row];
    cell.textLabel.font = kMainTextFieldTextFontMiddle;
    cell.textLabel.textColor = kMainTextColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self intoChangePassword];
    }else{
        [self intoFeedback];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
@end
