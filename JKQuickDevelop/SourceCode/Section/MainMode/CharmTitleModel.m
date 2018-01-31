//
//  CharmTitleModel.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/30.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "CharmTitleModel.h"

@implementation CharmTitleModel

- (instancetype)initWithChamTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.chamTitle = title;
        [self setObjectWithChamTitle:title];
    }
    return self;
}

- (void)setObjectWithChamTitle:(NSString *)chamTitle{
    if ([chamTitle isEqualToString:@"CHAIRMAN"]) {
        self.title = @"会长";
        self.image = @"VipCenter_Icon_Vip_G";
        self.level = 1;
    }else if ([chamTitle isEqualToString:@"EXC_CHAIRMAN"]){
        self.title = @"执行会长";
        self.image = @"VipCenter_Icon_Vip_F";
        self.level = 2;
    }else if ([chamTitle isEqualToString:@"ROUTINE_VICE_CHAIRMAN"]){
        self.title = @"常务副会长";
        self.image = @"VipCenter_Icon_Vip_E";
        self.level = 3;
    }else if ([chamTitle isEqualToString:@"VICE_CHAIRMAN"]){
        self.title = @"副会长";
        self.image = @"VipCenter_Icon_Vip_D";
        self.level = 4;
    }else if ([chamTitle isEqualToString:@"ROUTINE_DIRECTOR"]){
        self.title = @"常务理事";
        self.image = @"VipCenter_Icon_Vip_C";
        self.level = 5;
    }else if ([chamTitle isEqualToString:@"ORG_VIP"]){
        self.title = @"单位会员";
        self.image = @"VipCenter_Icon_Vip_B";
        self.level = 6;
    }else if ([chamTitle isEqualToString:@"INDIVIDUAL_VIP"]){
        self.title = @"个人会员";
        self.image = @"VipCenter_Icon_Vip_A";
        self.level = 7;
    }else{
        self.title = @"游客";
        self.image = @"";
        self.level = 8;
    }
}

@end
