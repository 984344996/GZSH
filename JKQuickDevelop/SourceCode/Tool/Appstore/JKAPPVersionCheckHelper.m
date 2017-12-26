//
//  JKAPPVersionCheckHelper.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/22.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKAPPVersionCheckHelper.h"
#import "JKNetworkHelper.h"
#import "AppDelegate.h"

@interface JKAPPVersionCheckHelper (){
    NSString *appLocalVersion;
    NSString *appStoreVersion;
    NSString *appStoreReleaseNotes;
}
/** 解析得到的JSON */
- (JKAppNewVersionType)parseVersion:(NSDictionary *)dic;

/** 显示跳过本版本的提示框 */
- (void)showVersionUpdateAlert:(JKAppNewVersionType)type;
@end
@implementation JKAPPVersionCheckHelper

/** 单例 */
+ (JKAPPVersionCheckHelper *)helper{
    static JKAPPVersionCheckHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JKAPPVersionCheckHelper alloc] init];
        instance.type = JKAppNewVersionTypeUnknown;
    });
    return instance;
}

#pragma mark - Public methods
- (void)checkAPPVersion{
    [JKNetworkHelper GET:APPLookUpAddr parameters:nil
                   cache:nil
                 success:^(id  _Nonnull responseObject) {
                     JKAppNewVersionType type = [self parseVersion:(NSDictionary *)responseObject];
                     [self showVersionUpdateAlert:type];
                     self.type = type;
                 } failure:^(NSError * _Nonnull error) {
                     return;
                 }];
}

#pragma mark - Private methods
- (JKAppNewVersionType)parseVersion:(NSDictionary *)dic{
    
    NSArray *results = dic[@"results"];
    if (results.count < 1){
        return JKAppNewVersionTypeUnknown;
    }
    
    appStoreVersion =  dic[@"results"][0][@"version"];
    appLocalVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    appStoreReleaseNotes = dic[@"results"][0][@"releaseNotes"];
    
    /** 如果跳过此版本返回 */
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:JKIngnoreVersionKey] isEqualToString:appStoreVersion]) {
        return JKAppNewVersionTypeUnknown;
    }
    
    NSMutableArray *appStoreVersionArray = (NSMutableArray *)[appStoreVersion componentsSeparatedByString:@"."];
    NSMutableArray *appLocalVersionArray = (NSMutableArray *)[appLocalVersion componentsSeparatedByString:@"."];
    
    /** 补充丢失版本号 */
    while (appStoreVersionArray.count < appLocalVersionArray.count) { [appStoreVersionArray addObject: @"0"]; }
    while (appLocalVersionArray.count < appStoreVersionArray.count) { [appLocalVersionArray addObject: @"0"]; }
    
    NSUInteger __block indexNotEqual = -1;
    [appStoreVersionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] > [[appLocalVersionArray objectAtIndex:idx] integerValue]) {
            indexNotEqual = idx;
            *stop = YES;
        }
    }];
    
    switch (indexNotEqual) {
        case 0:
            return JKAppNewVersionTypeForceUpgrade;
            break;
        case 1:
            return JKAppNewVersionTypeForceUpgrade;
            break;
        case 2:
            return JKAppNewVersionTypeUpgradeAvailable;
            break;
        default:
            return JKAppNewVersionTypeUnknown;
            break;
    }
    
    return JKAppNewVersionTypeUnknown;
}


- (void)showVersionUpdateAlert:(JKAppNewVersionType)type{
    if (type == JKAppNewVersionTypeUnknown) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizedString(@"Version update") message:appStoreReleaseNotes preferredStyle:UIAlertControllerStyleAlert];
    
    if (type != JKAppNewVersionTypeForceUpgrade) {
        /** 暂不升级 */
        UIAlertAction *actonCancel = [UIAlertAction actionWithTitle:LocalizedString(@"Not Now") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:actonCancel];
        
        /** 忽略这个版本 */
        UIAlertAction *actonIngnore = [UIAlertAction actionWithTitle:LocalizedString(@"Ingnore This Version") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self skipThisVersion];
        }];
        [alertController addAction:actonIngnore];
    }
    
    /** 现在升级 */
    UIAlertAction *actonUpgrade = [UIAlertAction actionWithTitle:LocalizedString(@"Upgrade Now") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self upgradeNow];
    }];
    [alertController addAction:actonUpgrade];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:true completion:nil];
}

/** 跳过此版本 */
- (void)skipThisVersion{
    NSUserDefaults *user =  [NSUserDefaults standardUserDefaults];
    [user setObject:appStoreVersion forKey:JKIngnoreVersionKey];
    [user synchronize];
}

/** 马上更新 */
- (void)upgradeNow{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPUpgradeAddr]];
}
@end
