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
#import "JKImagePicker.h"
#import "AddressModel.h"
#import "AddressParser.h"
#import "SelectedListView.h"
#import "APIServerSdk.h"
#import "UpLoadModel.h"
#import "NSString+Commen.h"
#import "CommonResponseModel.h"
#import <MBProgressHUD.h>
#import <LEEAlert.h>
#import <JKCategories.h>
#import <MJExtension.h>

@interface ApplicationStep2ViewController ()
@property (nonatomic, strong) ApplicationStep2View *applicationStep2View;
@property (nonatomic, strong) AccomplishModel *accomplishModel;
@property (nonatomic, strong) ZLPhotoActionSheet* photoActionSheet;

@property (nonatomic, strong) AddressModel *modelPro;
@property (nonatomic, strong) AddressModel *modelCity;
@property (nonatomic, strong) AddressModel *modelCountry;
@property (nonatomic, strong) UpLoadModel *upLoadModel;

@property (nonatomic, strong) UIImage *seletedImage;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation ApplicationStep2ViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"申请入会（2/4）";
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
        _photoActionSheet.configuration.navBarColor = kGreenColor;
        _photoActionSheet.configuration.navTitleColor = kWhiteColor;
        _photoActionSheet.configuration.maxSelectCount = 1;
        _photoActionSheet.configuration.allowSelectGif = NO;
        _photoActionSheet.configuration.allowSelectVideo = NO;
        _photoActionSheet.configuration.allowMixSelect = NO;
        _photoActionSheet.configuration.allowEditImage = YES;
    }
    return _photoActionSheet;
}

#pragma mark - Initialize

- (void)loadView{
    self.view = self.applicationStep2View;
}

- (void)configEvent{
    [super configEvent];
    [self bindRAC];
    
    @weakify(self)
    [[self.applicationStep2View.btnImage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [[JKImagePicker sharedInstance] showPopView:self allowedEdit:YES callback:^(UIImage *image) {
            [self.applicationStep2View.btnImage setImage:image forState:UIControlStateNormal];
            self.seletedImage = image;
            [self uploadImage];
        }];
    }];
    
    [[self.applicationStep2View.btnReupload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if(!self.seletedImage){
            [[HUDHelper sharedInstance] tipMessage:@"请先选取照片" inView:self.view];
        }
    }];
    
    self.applicationStep2View.inputAddressProvince.userInteractionEnabled = YES;
    self.applicationStep2View.inputAddressCity.userInteractionEnabled = YES;
    UITapGestureRecognizer *gen1 = [[UITapGestureRecognizer alloc] init];
    UITapGestureRecognizer *gen2 = [[UITapGestureRecognizer alloc] init];
    [self.applicationStep2View.inputAddressProvince addGestureRecognizer:gen1];
    [self.applicationStep2View.inputAddressCity addGestureRecognizer:gen2];
    
    [[gen1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        [self showAddressPick:@"1" parent_id:@"520000"];
    }];
    
    [[gen2 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (!self.modelCity) {
            [[HUDHelper sharedInstance] tipMessage:@"请先选择市" inView:self.view];
            return;
        }
        [self showAddressPick:@"2" parent_id:self.modelCity.id];
    }];
    
    [[self.applicationStep2View.btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if ([self checkForInfoComplete]) {
            ApplicationStep3ViewController *vc = [[ApplicationStep3ViewController alloc] init];
            vc.model = self.accomplishModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)showAddressPick:(NSString *)level_type parent_id:(NSString *)parent_id{
    NSArray *addressList = [[AddressParser sharedInstance] getArrayAddressNextLevel:parent_id level_type:level_type];
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = addressList;
    view.selectedBlock = ^(NSArray<AddressModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            if ([level_type isEqualToString:@"1"]) {
                self.modelCity = [array firstObject];
                self.modelCountry = nil;
            }else{
                self.modelCountry = [array firstObject];
            }
            [self addressSeleted];
        }];
    };
    
    NSString *title = [level_type isEqualToString:@"1"] ? @"请选择市" : @"请选择县";
    [LEEAlert alert].config
    .LeeTitle(title)
    .LeeCustomView(view)
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}

#pragma mark - Private methods

- (void)uploadImage{
    NSString *uuid = [NSString jk_UUID];
    self.hud = [[HUDHelper sharedInstance] loading:@"正在上传" inView:self.view];
    [APIServerSdk doUploadImage:self.seletedImage dir:@"avatar" name:uuid succeed:^(id obj) {
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:@"上传成功" inView:self.view];
        CommonResponseModel *cObj = obj;
        self.upLoadModel = [UpLoadModel mj_objectWithKeyValues:cObj.data];
        [self.applicationStep2View.btnReupload setTitle:@"重新上传" forState:UIControlStateNormal];
    } failed:^(NSString *error) {
        [[HUDHelper sharedInstance] stopLoading:self.hud];
        [[HUDHelper sharedInstance] tipMessage:error inView:self.view];
    }];
}

- (void)addressSeleted{
    if (self.modelCity) {
        self.applicationStep2View.inputAddressProvince.text = self.modelCity.short_name;
    }else{
        self.applicationStep2View.inputAddressProvince.text = @"-市-";
    }
    
    if (self.modelCountry) {
        self.applicationStep2View.inputAddressCity.text = self.modelCountry.short_name;
    }else{
        self.applicationStep2View.inputAddressCity.text = @"-县-";
    }
}

- (void)bindRAC{
    RAC(self.accomplishModel,name)            = [RACSignal
                                                 merge:@[self.applicationStep2View.inputName.rac_textSignal, RACObserve(self.applicationStep2View.inputName, text)]];
    RAC(self.accomplishModel,enterpriseName)  = [RACSignal
                                                 merge:@[self.applicationStep2View.inputCompany.rac_textSignal, RACObserve(self.applicationStep2View.inputCompany, text)]];
    
    RAC(self.accomplishModel,enterpriseTitle) = [RACSignal
                                                 merge:@[self.applicationStep2View.inpputCompayPosition.rac_textSignal, RACObserve(self.applicationStep2View.inpputCompayPosition, text)]];
    
    RAC(self.accomplishModel,enterpriseDescription) = [RACSignal
                                                       merge:@[self.applicationStep2View.inputCompanyInfo.rac_textSignal, RACObserve(self.applicationStep2View.inputCompanyInfo, text)]];
}

- (BOOL)checkForInfoComplete{
    BOOL isOK = YES;
    NSString *msg;
    if (!self.upLoadModel) {
        msg = @"请先上传头像";
        isOK = NO;
    }
    
    if ([NSString isEmpty:self.accomplishModel.name]) {
        msg =  msg ? msg : @"名字不能为空";
        isOK = NO;
    }
    
    if (!self.modelCity || !self.modelCountry) {
        msg = msg ? msg : @"请完善家乡地址";
        isOK = NO;
    }
    
    if ([NSString isEmpty:self.accomplishModel.enterpriseName]) {
        msg = msg ? msg :  @"请完善所属企业";
        isOK = NO;
    }
    
    if ([NSString isEmpty:self.accomplishModel.enterpriseTitle]) {
        msg = msg ? msg :  @"请完善公司职位";
        isOK = NO;
    }
    
    if ([NSString isEmpty:self.accomplishModel.enterpriseDescription]) {
        msg = msg ? msg :  @"请完善公司简介";
        isOK = NO;
    }
    if (msg) {
        [[HUDHelper sharedInstance] tipMessage:msg inView:self.view];
    }
    
    if (isOK) {
        self.accomplishModel.avatar = self.upLoadModel.url;
        self.accomplishModel.cityId = self.modelCity.id;
        self.accomplishModel.cityName = self.modelCity.short_name;
        self.accomplishModel.countyId = self.modelCountry.id;
        self.accomplishModel.countyName = self.modelCountry.short_name;
    }
    return isOK;
}

/// 限制字符长度
- (RACSignal *)limitLengthWithSignal:(RACSignal *)signal textLength:(int)textLength{
    return [signal map:^id(NSString *text) {
        return text.length <= textLength ? text : [text substringToIndex:textLength];
    }];
}

@end
