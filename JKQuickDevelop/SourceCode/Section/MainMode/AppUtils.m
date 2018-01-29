//
//  AppUtils.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/20.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "AppUtils.h"
#import <JKCategories.h>

@implementation AppUtils

+ (void)makePhoneCallTo:(NSString *)phone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
}

+ (void)sendSmsTo:(NSString *)phone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phone]]];
}

@end
