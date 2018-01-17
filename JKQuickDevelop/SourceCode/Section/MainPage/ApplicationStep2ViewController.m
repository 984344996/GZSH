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
#import "AccomplishModel.h"
#import <ZLPhotoActionSheet.h>

@interface ApplicationStep2ViewController ()
@property (nonatomic, strong) ApplicationStep2View *applicationStep2View;
@property (nonatomic, strong) AccomplishModel *accomplishModel;
@property (nonatomic, strong) ZLPhotoActionSheet* photoActionSheet;

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *proName;
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;

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

- (AccomplishModel *)accomplishModel{
    if (!_accomplishModel) {
        _accomplishModel = [[AccomplishModel alloc] init];
    }
    return _accomplishModel;
}

- (ZLPhotoActionSheet *)photoActionSheet{
    if (!_photoActionSheet) {
        _photoActionSheet = [[ZLPhotoActionSheet alloc] init];
        _photoActionSheet.sender = self;
        _photoActionSheet.navBarColor = kGreenColor;
        _photoActionSheet.navTitleColor = kWhiteColor;
        _photoActionSheet.maxSelectCount = 1;
        _photoActionSheet.allowSelectGif = NO;
        _photoActionSheet.allowSelectVideo = NO;
        _photoActionSheet.allowMixSelect = NO;
        _photoActionSheet.allowEditImage = YES;
    }
    return _photoActionSheet;
}
#pragma mark - Initialize

- (void)loadView{
    self.view = self.applicationStep2View;
}

- (void)configEvent{
    [super configEvent];
     @weakify(self)
    [[self.applicationStep2View.btnImage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    [[self.applicationStep2View.btnReupload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    self.applicationStep2View.inputAddressProvince.userInteractionEnabled = YES;
    self.applicationStep2View.inputAddressCity.userInteractionEnabled = YES;
    UITapGestureRecognizer *gen1 = [[UITapGestureRecognizer alloc] init];
    UITapGestureRecognizer *gen2 = [[UITapGestureRecognizer alloc] init];
    [self.applicationStep2View.inputAddressProvince addGestureRecognizer:gen1];
    [self.applicationStep2View.inputAddressProvince addGestureRecognizer:gen2];
    
    [[gen1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
    }];
    
    [[gen2 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
    }];
    
    [[self.applicationStep2View.btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ApplicationStep3ViewController *vc = [[ApplicationStep3ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - Private methods

- (void)bindRAC{
    RAC(self.accomplishModel,name)            = RACObserve(self.applicationStep2View.inputName, text);
    RAC(self.accomplishModel,avatar)          = RACObserve(self,avatar);
    RAC(self.accomplishModel,enterpriseName)  = RACObserve(self.applicationStep2View.inputCompany, text);
    RAC(self.accomplishModel,enterpriseTitle) = RACObserve(self.applicationStep2View.inpputCompayPosition, text);
    RAC(self.accomplishModel,enterpriseDescription) = RACObserve(self.applicationStep2View.inputCompanyInfo,text);
}

/// 限制字符长度
- (RACSignal *)limitLengthWithSignal:(RACSignal *)signal textLength:(int)textLength{
    return [signal map:^id(NSString *text) {
        return text.length <= textLength ? text : [text substringToIndex:textLength];
    }];
}

@end
