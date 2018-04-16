//
//  ApplicationStep4ViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "ApplicationStep4ViewController.h"
#import "ApplicationStep4View.h"
#import <ReactiveObjC.h>
#import <LEEAlert.h>
#import "APIServerSdk.h"
#import "HUDHelper.h"
#import "JKNetworkHelper.h"
#import "VipInfo.h"
#import "PayModel.h"
#import <MJExtension.h>
#import "CommonResponseModel.h"
#import <LEEAlert.h>
#import "JKSelectedListView.h"
#import "ThirdPayHelper.h"
#import <JKCategories.h>
#import "AppDataFlowHelper.h"

@interface ApplicationStep4ViewController ()
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) ApplicationStep4View *applicationStep4View;
@property (nonatomic, strong) NSMutableArray *vipArray;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ApplicationStep4ViewController

#pragma mark - Life circle

static NSString* VipInfoFormat = @"%@会员价格为%.2f,您可直接支付成为会员！";

- (void)viewDidLoad {
    self.title = @"申请入会（4/4）";
    self.token = @"token_inactive_ezSocpdeYjV532eqns9dRoopw8m2SYpJHSraet";
    
    self.index = -1;
    self.vipArray = [NSMutableArray array];
    [JKNetworkHelper setToken:self.token];
    [super viewDidLoad];
}

- (BOOL)interactivePopEnable{
    return NO;
}

- (ApplicationStep4View *)applicationStep4View{
    if (!_applicationStep4View) {
        _applicationStep4View = [[ApplicationStep4View alloc] init];
    }
    return _applicationStep4View;
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

#pragma mark - Init

- (void)loadView{
    self.view = self.applicationStep4View;
}

- (void)configEvent{
    [super configEvent];
    self.applicationStep4View.pannelVip.userInteractionEnabled = YES;
    UITapGestureRecognizer *gen = [[UITapGestureRecognizer alloc] init];
    [self.applicationStep4View.pannelVip addGestureRecognizer:gen];
    @weakify(self)
    [[gen rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        if (self.vipArray.count == 0) {
            [[HUDHelper sharedInstance] tipMessage:@"未获取到会员信息" inView:self.view];
            return;
        }
        [self showVipAlert];
    }];
    
    RACSignal *sign = [RACObserve(self, index) distinctUntilChanged];
    [sign subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger i = ((NSNumber *)x).integerValue;
        if (i < 0) {
            return ;
        }
        VipInfo *info = self.vipArray[i];
        self.applicationStep4View.labelTitle.text = info.name;
        self.applicationStep4View.hintLabel.text = [NSString stringWithFormat:VipInfoFormat,info.name,info.price.floatValue];
        if(info.needCheck){
            [self.applicationStep4View.buttonPay jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
            [self.applicationStep4View.buttonPay jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
            [self.applicationStep4View.buttonPay setTitle:@"提交审核" forState:UIControlStateNormal];
        }else{
            [self.applicationStep4View.buttonPay jk_setBackgroundColor:kMainYellowColor forState:UIControlStateNormal];
            [self.applicationStep4View.buttonPay jk_setBackgroundColor:[kMainYellowColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
            [self.applicationStep4View.buttonPay setTitle:@"支付" forState:UIControlStateNormal];
        }
    }];
    
    [[self.applicationStep4View.buttonPay rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectedThirdTypeAndPay];
    }];
}

- (void)configData{
    [super configData];
    [self GetVipData];
}

#pragma mark - Private methods

- (void)selectedThirdTypeAndPay{
    if (self.index < 0) {
        [[HUDHelper sharedInstance] tipMessage:@"请先选择会员类型" inView:self.view];
        return;
    }
    
    NSArray *array = @[@{@"name":@"微信支付",@"type":@"wx"},@{@"name":@"支付宝支付",@"type":@"alipay"}];
    JKSelectedListView *view = [[JKSelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle            = YES;
    view.array               = array;
    view.titleKey            = @"name";
    
    WEAKSELF
    view.selectedBlock = ^(NSArray *array) {
        [LEEAlert closeWithCompletionBlock:^{
            STRONGSELF
            NSUInteger index = [array indexOfObject:[array firstObject]];
            NSObject *obj = array[index];
            NSString *type = [obj valueForKey:@"type"];
            VipInfo *info = self.vipArray[self.index];
            [strongSelf DoPayVip:type vip:info];
        }];
    };
    NSString *title = @"请选择支付方式";
    [LEEAlert alert].config
    .LeeTitle(title)
    .LeeCustomView(view)
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}

- (void)showVipAlert{
    JKSelectedListView *view = [[JKSelectedListView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) style:UITableViewStylePlain];
    view.isSingle            = YES;
    view.array               = self.vipArray;
    view.titleKey            = @"name";
    
    WEAKSELF
    view.selectedBlock = ^(NSArray *array) {
        [LEEAlert closeWithCompletionBlock:^{
            STRONGSELF
            NSUInteger index = [strongSelf.vipArray indexOfObject:[array firstObject]];
            strongSelf.index = index;
        }];
    };
    
    NSString *title = @"请选择会员类型";
    [LEEAlert alert].config
    .LeeTitle(title)
    .LeeCustomView(view)
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}

- (void)GetVipData{
    [APIServerSdk doGetVip:^(id obj) {
        CommonResponseModel *model = (CommonResponseModel *)obj;
        NSMutableArray *array = [VipInfo mj_objectArrayWithKeyValuesArray:(model.data)];
        [AppDataFlowHelper saveVipList:model.data];
        if (array.count > 0) {
            self.vipArray = array;
            self.index = 0;
        }
    } failed:^(NSString *error) {
    }];
}

- (void)DoPayVip:(NSString *)channel vip:(VipInfo *)vip{
    [APIServerSdk doDeleteUnPay:^(id obj) {
        WEAKSELF
        [APIServerSdk doFirstBuy:channel vipId:vip.Id succeed:^(id obj) {
            STRONGSELF
            if (vip.needCheck) {
                [[HUDHelper sharedInstance] tipMessage:@"提交审核成功,等待短信通知" inView:strongSelf.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                return ;
            }
            CommonResponseModel *model = (CommonResponseModel *)obj;
            PayModel *payModel = [PayModel mj_objectWithKeyValues:(model.data)];
            [[ThirdPayHelper sharedInstance] thirdPay:channel payModel:payModel callback:^(PayType type, PayResult result, NSString *message) {
                if (result == PayResultSuccess) {
                    [[HUDHelper sharedInstance] tipMessage:@"支付成功" inView:strongSelf.view];
                    [LEEAlert alert]
                    .config
                    .LeeTitle(@"支付成功")
                    .LeeAction(@"确定", ^{
                        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                    })
                    .LeeAddContent(^(UILabel *label) {
                        label.text = @"初始密码为123456，请尽快修改密码";
                        label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
                        label.textAlignment = NSTextAlignmentCenter;
                    })
                    .LeeShow();
                }else{
                    [[HUDHelper sharedInstance] tipMessage:@"支付失败" inView:strongSelf.view];
                }
            }];
        } failed:^(NSString *error) {
            STRONGSELF
            [[HUDHelper sharedInstance] tipMessage:@"订单获取失败" inView:strongSelf.view];
        }];
    } failed:nil];
}


@end
