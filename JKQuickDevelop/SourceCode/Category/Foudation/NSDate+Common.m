//
//  NSDate+Common.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "NSDate+Common.h"
#import <JKCategories.h>

@implementation NSDate (Common)

#define kMinuteTimeInterval (60)
#define kHourTimeInterval   (60 * kMinuteTimeInterval)
#define kDayTimeInterval    (24 * kHourTimeInterval)
#define kWeekTimeInterval   (7  * kDayTimeInterval)
#define kMonthTimeInterval  (30 * kDayTimeInterval)
#define kYearTimeInterval   (12 * kMonthTimeInterval)


- (BOOL)isToday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate])
    {
        return YES;
    }
    return NO;
}

- (BOOL)isYesterday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    NSDate *yesterday = [today dateByAddingTimeInterval: -kDayTimeInterval];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([yesterday isEqualToDate:otherDate])
    {
        return YES;
    }
    return NO;

}

- (NSString *)shortTimeTextOfDate
{
    NSDate *date = self;
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
    
    interval = -interval;
    
    if ([date isToday])
    {
        // 今天的消息
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"aHH:mm"];
        [dateFormat setAMSymbol:@"上午"];
        [dateFormat setPMSymbol:@"下午"];
        NSString *dateString = [dateFormat stringFromDate:date];
        return dateString;
    }
    else if ([date isYesterday])
    {
        // 昨天
        return @"昨天";
    }
    else if (interval < kWeekTimeInterval)
    {
        // 最近一周
        // 实例化一个NSDateFormatter对象
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormat setDateFormat:@"ccc"];
        NSString *dateString = [dateFormat stringFromDate:date];
        return dateString;
    }
    else
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        
        if ([components year] == [today year])
        {
            // 今年
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"MM-dd"];
            NSString *dateString = [dateFormat stringFromDate:date];
            return dateString;
        }
        else
        {
            // 往年
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yy-MM-dd"];
            NSString *dateString = [dateFormat stringFromDate:date];
            return dateString;
            
        }
    }
    return nil;
}

- (NSString *)timeTextOfDate
{
    NSDate *date = self;
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
    
    interval = -interval;
    
    // 今天的消息
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"aHH:mm"];
    [dateFormat setAMSymbol:@"上午"];
    [dateFormat setPMSymbol:@"下午"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    if ([date isToday])
    {
        // 今天的消息
        return dateString;
    }
    else if ([date isYesterday])
    {
        // 昨天
        return [NSString stringWithFormat:@"昨天 %@", dateString];
    }
    else if (interval < kWeekTimeInterval)
    {
        // 最近一周
        // 实例化一个NSDateFormatter对象
        NSDateFormatter* weekFor = [[NSDateFormatter alloc] init];
        weekFor.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [weekFor setDateFormat:@"ccc"];
        NSString *weekStr = [weekFor stringFromDate:date];
        return [NSString stringWithFormat:@"%@ %@", weekStr, dateString];
    }
    else
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        
        if ([components year] == [today year])
        {
            // 今年
            NSDateFormatter *mdFor = [[NSDateFormatter alloc] init];
            [mdFor setDateFormat:@"MM-dd"];
            NSString *mdStr = [mdFor stringFromDate:date];
            return [NSString stringWithFormat:@"%@ %@", mdStr, dateString];
        }
        else
        {
            // 往年
            NSDateFormatter *ymdFormat = [[NSDateFormatter alloc] init];
            [ymdFormat setDateFormat:@"yy-MM-dd"];
            NSString *ymdString = [ymdFormat stringFromDate:date];
            return [NSString stringWithFormat:@"%@ %@", ymdString, dateString];;
            
        }
    }
    return nil;
}

#pragma mark - 格式转换

+ (NSDateFormatter *)getFormatterUTC:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return formatter;
}

+ (NSDateFormatter *)getFormatterLocal:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    return formatter;
}

+ (NSString *)parseServerDateTimeToFormat:(NSString *)dateString format:(NSString *)format{
    if (!dateString) {
        return @"";
    }
    NSDateFormatter *fromFormat = [self getFormatterLocal:kServerDateTimeFormat];
    NSDate *date = [fromFormat dateFromString:dateString];
    if (!date) {
        return @"";
    }
    NSDateFormatter *toFormat = [self getFormatterLocal:format];
    NSString *str = [toFormat stringFromDate:date];
    return str;
}

+ (NSString *)parseTimeToCYMD:(NSString *)dateString shortYear:(BOOL)shortYear{
    if (!dateString) {
        return @"";
    }
    NSDateFormatter *fromFormat = [self getFormatterLocal:kServerDateTimeFormat];
    NSDate *date = [fromFormat dateFromString:dateString];
    if (!date) {
        return @"";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    if (shortYear) {
        year = year % 100;
        NSString *str = [NSString stringWithFormat:@"%2ld年%ld月%ld日",year,month,day];
        return str;
    }
    
    NSString *str = [NSString stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
    return str;
}

+ (NSString *)parseTimeToCMD:(NSString *)dateString{
    if (!dateString) {
        return @"";
    }
    NSDateFormatter *fromFormat = [self getFormatterLocal:kServerDateTimeFormat];
    NSDate *date = [fromFormat dateFromString:dateString];
    if (!date) {
        return @"";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSString *str = [NSString stringWithFormat:@"%ld月%ld日",month,day];
    return str;
}

+ (NSString *)getMomentDateStamp:(NSString *)dateString{
    NSDateFormatter *fromFormat = [self getFormatterLocal:kServerDateTimeFormat];
    NSDate *date                = [fromFormat dateFromString:dateString];
    NSString *str               = [NSDate jk_timeInfoWithDate:date];
    return str;
}
@end
