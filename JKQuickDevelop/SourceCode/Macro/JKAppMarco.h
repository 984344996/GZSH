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

#define APIServerProduct @"http://gzsh.jyapi.cn/app"
#define APIServerDevelop @"http://gzsh.jyapi.cn/app"

#define BaseFileUrlProduct @"http://gzsh.jyapi.cn"
#define BaseFileUrlDevelop @"http://gzsh.jyapi.cn"

#define APIServerCerPath @""   // SSL验证证书
#define APPHttpCacheTime 10080 // http缓存时间 默认为一周

#define WXAppId @"wxa5af774c1e0ca22a"
#define AlAppId @"appid"

#if DEBUG
#define APIServer APIServerDevelop
#define BaseFileUrl BaseFileUrlDevelop
#else
#define APIServer APIServerProduct
#define BaseFileUrl BaseFileUrlProduct
#endif

// 根据BaseUrl获取图片绝对Url
static __inline__ NSURL* GetImageUrl(NSString *relativeUrl)
{
    if (!relativeUrl) {
        return nil;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseFileUrl,relativeUrl];
    return [NSURL URLWithString:url];
}

static __inline__ NSString* GetImageString(NSString *relativeUrl)
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseFileUrl,relativeUrl];
    return url;
}


// 开关配置
#define kJKSupportNetOberve 1
#define kJKSupportRater 0
#define kJKSupportUpgrade 0
#define kJKSupportPush 0
#define kJKUsingStartPage 0
#define kJKUsingSplahPage 0
#define kJKUsingLoginPage 1

#define kSupportWxPay 1
#define kSupportAliPay 1
#endif /* JKSwitchMarco_h */
