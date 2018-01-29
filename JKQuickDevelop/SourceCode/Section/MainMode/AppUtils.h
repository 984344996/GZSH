//
//  AppUtils.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/20.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject

+ (void)makePhoneCallTo:(NSString *)phone;
+ (void)sendSmsTo:(NSString *)phone;

@end
