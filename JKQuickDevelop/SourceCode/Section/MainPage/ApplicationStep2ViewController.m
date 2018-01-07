//
//  ApplicationStep2ViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep2ViewController.h"
#import "ApplicationStep3ViewController.h"
#import "ApplicationStep2View.h"
#import <ReactiveObjC.h>
#import <IQKeyboardManager.h>

@interface ApplicationStep2ViewController ()
@property (nonatomic, strong) ApplicationStep2View *applicationStep2View;
@end

@implementation ApplicationStep2ViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"申请入会（2/3）";
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (BOOL)interactivePopEnable{
    return NO;
}

- (ApplicationStep2View *)applicationStep2View{
    if (!_applicationStep2View) {
        _applicationStep2View = [[ApplicationStep2View alloc] init];
    }
    return _applicationStep2View;
}

#pragma mark - Initialize

- (void)loadView{
    self.view = self.applicationStep2View;
}

- (void)configEvent{
    [super configEvent];
    
    @weakify(self)
    [[self.applicationStep2View.btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ApplicationStep3ViewController *vc = [[ApplicationStep3ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
