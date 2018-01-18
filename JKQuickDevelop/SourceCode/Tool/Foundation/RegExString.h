//
//  RegExString.h
//  MuZhiStudio
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegExString : NSObject

+ (BOOL)checkTelNumber:(NSString *) telNumber;
+ (BOOL)checkUserName : (NSString *) userName;
+ (BOOL)checkPassword:(NSString *) password;
+ (BOOL)checkUserIdCard: (NSString *) idCard;
+ (BOOL)checkURL : (NSString *) url;
+ (BOOL)checkVerificationCode : (NSString *) code;

@end
