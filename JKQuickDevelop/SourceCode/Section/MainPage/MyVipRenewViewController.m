//
//  MyVipRenewViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MyVipRenewViewController.h"
#import "MyVipRenewView.h"

@interface MyVipRenewViewController ()
@property (nonatomic, strong) MyVipRenewView *renewView;
@end

@implementation MyVipRenewViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"会员续费";
    [super viewDidLoad];
}

- (BOOL)interactivePopEnable{
    return YES;
}

- (MyVipRenewView *)renewView{
    if (!_renewView) {
        _renewView = [[MyVipRenewView alloc] init];
    }
    return _renewView;
}

#pragma mark - Init

- (void)loadView{
    self.view = self.renewView;
}

- (void)configEvent{
    [super configEvent];
}

- (void)configData{
    [super configData];
}

@end
