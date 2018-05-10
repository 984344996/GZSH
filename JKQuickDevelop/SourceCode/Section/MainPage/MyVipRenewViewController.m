//
//  MyVipRenewViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MyVipRenewViewController.h"
#import "MyVipRenewView.h"
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

@interface MyVipRenewViewController ()
@property (nonatomic, strong) MyVipRenewView *renewView;
@property (nonatomic, strong) NSMutableArray *vipArray;
@property (nonatomic, assign) NSInteger index;
@end

@implementation MyVipRenewViewController
static NSString* VipInfoFormat = @"%@会员价格为%.2f,您可直接支付续费！";

#pragma mark - Life circle

- (void)viewDidLoad {
    self.title = @"会员续费";
    self.index = -1;
    self.vipArray = [NSMutableArray array];
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
    
    self.renewView.pannelVip.userInteractionEnabled = YES;
    UITapGestureRecognizer *gen = [[UITapGestureRecognizer alloc] init];
    [self.renewView.pannelVip addGestureRecognizer:gen];
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
        self.renewView.labelTitle.text = info.name;
        self.renewView.hintLabel.text = [NSString stringWithFormat:VipInfoFormat,info.name,info.price.floatValue];
        if([info.Id isEqualToString:self.charmTitleLast]){
            [self.renewView.buttonPay jk_setBackgroundColor:kMainYellowColor forState:UIControlStateNormal];
            [self.renewView.buttonPay jk_setBackgroundColor:[kMainYellowColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
            [self.renewView.buttonPay setTitle:@"支付" forState:UIControlStateNormal];
        }else{
            [self.renewView.buttonPay jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
            [self.renewView.buttonPay jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
            [self.renewView.buttonPay setTitle:@"提交审核" forState:UIControlStateNormal];
        }
    }];
    
    [[self.renewView.buttonPay rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectedThirdTypeAndPay];
    }];
}

- (void)configData{
    [super configData];
    [self GetVipData];
}

#pragma mark - Private methods

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


- (void)selectedThirdTypeAndPay{
    if (self.index < 0) {
        [[HUDHelper sharedInstance] tipMessage:@"请先选择会员类型" inView:self.view];
        return;
    }
    
    VipInfo *vip = self.vipArray[self.index];
    if (![vip.Id isEqualToString:self.charmTitleLast]) {
        [self DoPayVip:@"" vip:vip];
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
            [strongSelf DoPayVip:type vip:vip];
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
        [APIServerSdk doRenew:channel vipId:vip.Id succeed:^(id obj) {
            STRONGSELF
            if (![vip.Id isEqualToString:self.charmTitleLast]) {
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
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    });
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
