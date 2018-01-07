//
//  ApplicationStep3ViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep3ViewController.h"
#import "ApplicationStep3View.h"
#import <ReactiveObjC.h>
#import <IQKeyboardManager.h>

@interface ApplicationStep3ViewController ()
@property (nonatomic, strong) ApplicationStep3View *applicationStep3View;
@end

@implementation ApplicationStep3ViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"申请入会（3/3）";
    [super viewDidLoad];
}

- (ApplicationStep3View *)applicationStep3View{
    if (!_applicationStep3View) {
        _applicationStep3View = [[ApplicationStep3View alloc] init];
    }
    return _applicationStep3View;
}

#pragma mark - Initialize

- (void)loadView{
    self.view = self.applicationStep3View;
}

- (void)configEvent{
    [super configEvent];
    
    @weakify(self)
    [[self.applicationStep3View.btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


@end
