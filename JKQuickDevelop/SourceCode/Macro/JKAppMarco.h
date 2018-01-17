//
//  JKAppMarco.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#ifndef JKAppMarco_h
#define JKAppMarco_h

// App基本配置
#define APPID @"1108788151"
#define APPLookUpAddr [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APPID]
#define APPUpgradeAddr [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/SMZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID]

#define APIServerProduct @"https://app.product.com"
#define APIServerDevelop @"http://gzsh.projects.jyapi.cn/app"
#define APIServerCerPath @""   // SSL验证证书
#define APPHttpCacheTime 10080 // http缓存时间 默认为一周

#if DEBUG
#define APIServer APIServerDevelop
#else
#define APIServer APIServerProduct
#endif

// 开关配置
#define kJKSupportNetOberve 1
#define kJKSupportRater 0
#define kJKSupportUpgrade 0
#define kJKSupportPush 0
#define kJKUsingStartPage 0
#define kJKUsingSplahPage 0
#define kJKUsingLoginPage 1

#endif /* JKSwitchMarco_h */
