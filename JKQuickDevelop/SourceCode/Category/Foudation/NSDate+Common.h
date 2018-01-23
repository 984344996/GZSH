//
//  NSDate+Common.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kServerDateTimeFormat @"yyyy-MM-dd HH:mm:ss"
#define kTurnState1 @"yyyy/MM/dd"
#define kTurnState2 @"yyyy-MM-dd"
#define kTurnState3 @"HH:mm"
#define kTurnState5 @"yyyy/MM/dd HH:mm:ss"

@interface NSDate (Common)

- (BOOL)isToday;

- (BOOL)isYesterday;

- (NSString *)shortTimeTextOfDate;

- (NSString *)timeTextOfDate;

+ (NSString *)parseServerDateTimeToFormat:(NSString *)dateString format:(NSString *)format;
+ (NSString *)parseTimeToCYMD:(NSString *)dateString shortYear:(BOOL)shortYear;
+ (NSString *)parseTimeToCMD:(NSString *)dateString;
+ (NSString *)getMomentDateStamp:(NSString *)dateString;

@end
