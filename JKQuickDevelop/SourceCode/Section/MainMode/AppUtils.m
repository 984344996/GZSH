//
//  AppUtils.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/20.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "AppUtils.h"
#import <JKCategories.h>
#import "DynamicMsg+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation AppUtils

// 数据库操作
+ (int)fetchDynamicMsgCount{
    NSUInteger count = [DynamicMsg MR_countOfEntities];
    if (count > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kJKReddotNotification object:nil userInfo:@{@"index":[NSNumber numberWithUnsignedInteger:1],@"number":[NSNumber numberWithUnsignedInteger:count]}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kJKReddotNotification object:nil userInfo:@{@"index":[NSNumber numberWithUnsignedInteger:1],@"number":[NSNumber numberWithUnsignedInteger:0]}];
    }
    return (int)count;
}

+ (void)makePhoneCallTo:(NSString *)phone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
}

+ (void)sendSmsTo:(NSString *)phone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phone]]];
}

@end
