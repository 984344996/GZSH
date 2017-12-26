//
//  HUDHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "MBProgressHUD.h"
#import "NSObject+CommonBlock.h"

@interface HUDHelper : NSObject
{
@private
    MBProgressHUD *_syncHUD;
}

+ (HUDHelper *)sharedInstance;

// 网络请求
- (MBProgressHUD *)loading;
- (MBProgressHUD *)loading:(NSString *)msg;
- (MBProgressHUD *)loading:(NSString *)msg inView:(UIView *)view;


- (void)loading:(NSString *)msg delay:(CGFloat)seconds execute:(void (^)())exec completion:(void (^)())completion;

- (void)stopLoading:(MBProgressHUD *)hud;
- (void)stopLoading:(MBProgressHUD *)hud message:(NSString *)msg;
- (void)stopLoading:(MBProgressHUD *)hud message:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion;

- (void)tipMessage:(NSString *)msg;
- (void)tipMessage:(NSString *)msg inView:(UIView *)inView;
- (void)tipMessage:(NSString *)msg inView:(UIView *)inView delay:(CGFloat)seconds;
- (void)tipMessage:(NSString *)msg inView:(UIView *)inView delay:(CGFloat)seconds completion:(void (^)())completion;

// 网络请求
- (void)syncLoading;
- (void)syncLoading:(NSString *)msg;
- (void)syncLoading:(NSString *)msg inView:(UIView *)view;

- (void)syncStopLoading;
- (void)syncStopLoadingMessage:(NSString *)msg;
- (void)syncStopLoadingMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion;

@end

