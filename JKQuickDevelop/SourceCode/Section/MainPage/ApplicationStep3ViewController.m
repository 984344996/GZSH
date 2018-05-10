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
#import <ReactiveObjC.h>
#import "HUDHelper.h"
#import <MBProgressHUD.h>
#import "APIServerSdk.h"
#import <LEEAlert.h>
#import "ApplicationStep4ViewController.h"

@interface ApplicationStep3ViewController ()
@property (nonatomic, strong) ApplicationStep3View *applicationStep3View;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation ApplicationStep3ViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"申请入会（3/4）";
    [super viewDidLoad];
}

- (BOOL)interactivePopEnable{
    return NO;
}

- (ApplicationStep3View *)applicationStep3View{
    if (!_applicationStep3View) {
        _applicationStep3View = [[ApplicationStep3View alloc] init];
    }
    return _applicationStep3View;
}

- (void)popBack{
    [LEEAlert alert]
    .config
    .LeeTitle(@"退出申请?")
    .LeeCancelAction(@"取消", ^{
        
    })
    .LeeAction(@"确定", ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = @"退出申请后之前步骤无效！";
        label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
        label.textAlignment = NSTextAlignmentCenter;
    })
    .LeeShow();
}

#pragma mark - Private methods

- (void)bindRAC{
    RAC(self.model,recommend)            = [RACSignal
                                            merge:@[self.applicationStep3View.inputPhone.rac_textSignal, RACObserve(self.applicationStep3View.inputPhone, text)]];
    
    
    RAC(self.model,supplement)  = [RACSignal
                                   merge:@[self.applicationStep3View.inputAppend.rac_textSignal, RACObserve(self.applicationStep3View.inputAppend, text)]];
}

- (void)doApplication{
    self.hud              = [[HUDHelper sharedInstance] loading:@"正在申请" inView:self.view];
    NSString *companyDesc = [NSString stringWithFormat:@"[{\"inputContent\":\"%@\"}]",self.model.enterpriseDescription];
    self.model.enterpriseDescription = companyDesc;
    self.model.selfbuying = YES;
    WEAKSELF
    [APIServerSdk doAccomplish:self.model succeed:^(id obj) {
        STRONGSELF
        [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
        ApplicationStep4ViewController *vc =  [[ApplicationStep4ViewController alloc] init];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    } failed:^(NSString *error) {
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:error inView:self.view];
    }];
}

#pragma mark - Initialize

- (void)loadView{
    self.view = self.applicationStep3View;
}

- (void)configEvent{
    [super configEvent];
    [self bindRAC];
    
    @weakify(self)
    [[self.applicationStep3View.btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self doApplication];
    }];
}


@end
