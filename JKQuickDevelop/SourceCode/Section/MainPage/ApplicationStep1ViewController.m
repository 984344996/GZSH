//
//  ApplicationStep1ViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep1ViewController.h"
#import "ApplicationStep2ViewController.h"
#import "ApplicationStep1View.h"
#import <ReactiveObjC.h>

@interface ApplicationStep1ViewController ()
@property (nonatomic, strong) ApplicationStep1View *applicationStep1View;
@end

@implementation ApplicationStep1ViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"申请入会（1/3）";
    [super viewDidLoad];
}

- (BOOL)interactivePopEnable{
    return NO;
}

- (ApplicationStep1View *)applicationStep1View{
    if (!_applicationStep1View) {
        _applicationStep1View = [[ApplicationStep1View alloc] init];
    }
    return _applicationStep1View;
}

#pragma mark - Initialize

- (void)loadView{
    self.view = self.applicationStep1View;
}

- (void)configEvent{
    [super configEvent];
    
    @weakify(self)
    [[self.applicationStep1View.buttonNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ApplicationStep2ViewController *vc = [[ApplicationStep2ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
@end
