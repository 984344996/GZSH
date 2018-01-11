//
//  EnterpriseModel.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/11.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "EnterpriseModel.h"
#import <MJExtension.h>

@implementation EnterpriseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"desc":@"description"
             };
}

@end
