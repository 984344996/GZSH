//
//  SplashViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/9.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKBaseViewController.h"
/**
 启动广告页面
 */
@interface SplashViewController : JKBaseViewController


/**
 检测是否需启动广告页
 */
+(BOOL)checkIfNeedSplash;

@end
