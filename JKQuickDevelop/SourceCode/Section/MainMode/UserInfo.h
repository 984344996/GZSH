//
//  UserInfo.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnterpriseModel.h"
#import "VipInfo.h"

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *chamTitle; // 商会头衔
@property (nonatomic, strong) EnterpriseModel *enterprise;
@property (nonatomic, strong) NSString *enterpriseTitle;
@property (nonatomic, strong) NSString *vipState; // VALID、INVALID
@property (nonatomic, strong) VipInfo *vipInfo;
@end
