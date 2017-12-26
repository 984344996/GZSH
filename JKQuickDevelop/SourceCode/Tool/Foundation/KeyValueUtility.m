//
//  KeyValueUtility.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/14.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "KeyValueUtility.h"
#import "PathUtility.h"

NSString *const JKLastAppVersion = @"JKLastAppVersion";
@implementation KeyValueUtility

#pragma mark - Save to NSUserDefaults
+ (void)setValue:(id)value forKey:(NSString *)key{
    NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
    [user setValue:value forKey:key];
    [user synchronize];
}

+ (id)getValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Save to Plist
+(void)checkPlistOrCreate:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSString *copyItem = [[NSBundle mainBundle] pathForResource:@"temp" ofType:@".plist"];
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:copyItem toPath:path error:&error];
        if (error) {
            DLog(@"KeyValueUtility create failed");
        }
    }
}

+(void)setValueToPlist:(NSString *)pname value:(id)value forKey:(NSString *)key{
    NSString *plist          = [PathUtility getDocumentPath];
    plist                    = [plist stringByAppendingPathComponent:pname];
    [self checkPlistOrCreate:plist];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plist];
    [dic setObject:value forKey:key];
    [dic writeToFile:plist atomically:YES];
}

+ (id)getValueForFromPlist:(NSString *)pname forKey:(NSString *)key{
    NSString *plist   = [PathUtility getDocumentPath];
    plist             = [plist stringByAppendingPathComponent:pname];

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plist];
    return [dic objectForKey:key];
}


@end
