//
//  ResetPasswordViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordView.h"
#import <ReactiveObjC.h>

@interface ResetPasswordViewController ()

@property (nonatomic, strong) ResetPasswordView *resetView;

@end

@implementation ResetPasswordViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"忘记密码";
    [super viewDidLoad];
}

- (BOOL)interactivePopEnable{
    return NO;
}

- (ResetPasswordView *)resetView{
    if (!_resetView) {
        _resetView = [[ResetPasswordView alloc] init];
    }
    return _resetView;
}

#pragma mark - Initialize

- (void)loadView{
    self.view = self.resetView;
}

- (void)configEvent{
    [super configEvent];
    
    @weakify(self)
    [[self.resetView.buttonModify rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end
