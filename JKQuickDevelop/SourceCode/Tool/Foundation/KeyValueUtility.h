//
//  KeyValueUtility.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/14.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString *const JKLastAppVersion;

@interface KeyValueUtility : NSObject

/**
 设置键值到NSUserDefaults

 @param value 值
 @param key 键
 */
+(void)setValue:(id __nullable)value forKey:(NSString *)key;


/**
 从NSUserDefaults获取数据

 @param key 键
 @return 值
 */
+(id __nullable)getValueForKey:(NSString *)key;



/**
 设置键值到指定的Plist文件中

 @param pname plist名字
 @param value 值
 @param key 键
 */
+(void)setValueToPlist:(NSString *)pname value:(id __nullable)value forKey:(NSString *)key;


/**
 从指定的Plist中获取数据

 @param pname plist名字
 @param key 键
 @return 值
 */
+(id __nullable)getValueForFromPlist:(NSString *)pname forKey:(NSString *)key;
@end
NS_ASSUME_NONNULL_END
