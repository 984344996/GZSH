//
//  StartPageViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/9.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKBaseViewController.h"
/**
 首次启动滑动页面
 */
@interface StartPageViewController : JKBaseViewController

/**
 检查是否需要进入启动页
 */
+(BOOL)checkIfNeedStartPage;

@end
