//
//  JKAPPVersionCheckHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/22.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 跳过版本号保存的Key */
#define JKIngnoreVersionKey @"JKIngnoreVersionKey"

/**
 更新严重等级

 - AppNewVersionTypeUnknown: 未知
 - AppNewVersionTypeNoUpgrade: 没有更新
 - AppNewVersionTypeUpgradeAvailable: 可用更新
 - AppNewVersionTypeForceUpgrade: 强行更新
 */
typedef NS_ENUM(NSUInteger,JKAppNewVersionType){
    JKAppNewVersionTypeUnknown,
    JKAppNewVersionTypeNoUpgrade,
    JKAppNewVersionTypeUpgradeAvailable,
    JKAppNewVersionTypeForceUpgrade
};

@interface JKAPPVersionCheckHelper: NSObject
@property (nonatomic, assign)JKAppNewVersionType type;

/** 获取单例 */
+ (JKAPPVersionCheckHelper *)helper;

/**
 检查更新
 */
- (void)checkAPPVersion;
@end
