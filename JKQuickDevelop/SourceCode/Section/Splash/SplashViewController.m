//
//  SplashViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/9.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "SplashViewController.h"
#import "JKTickDownButton.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define JKTestImageUrl @"https://image.mzliaoba.com/pic/common/5457187535/20160818/b0fc69ca-63c4-4661-8e37-dc574a325914adtest2.png"
#define JKSplashDownloadMaxTime 5
@interface SplashViewController ()<JKTickDownButtonDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) JKTickDownButton *btnTick;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Overrite
- (void)configView{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, JK_SCREEN_HEIGHT)];
    [self.view addSubview:self.imageView];
    
    self.btnTick          = [[JKTickDownButton alloc] init:CGRectMake(JK_SCREEN_WIDTH - 65, 20, 45, 45) time:5];
    self.btnTick.delegate = self;
    [self.btnTick setHidden:YES];
    [self.view addSubview:self.btnTick];
}

- (void)configEvent{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:JKSplashDownloadMaxTime target:self selector:@selector(tickDown:) userInfo:nil repeats:NO];
}

- (void)configData{
    NSURL *url = [NSURL URLWithString:JKTestImageUrl];
    WEAKSELF
    [self.imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [weakSelf.timer invalidate];
        if (enteredMainPage) {
            return;
        }
        if (image) {
            weakSelf.imageView.image = image;
            [weakSelf.btnTick setHidden:NO];
            [weakSelf.btnTick start];
        }else{
            [weakSelf enterMainPage];
        }
    }];
}

#pragma mark - Public methods
+(BOOL)checkIfNeedSplash{
    return YES;
}

#pragma mark - Private methods
static BOOL enteredMainPage = NO;
-(void)enterMainPage{
    if (enteredMainPage) {
        return;
    }
    enteredMainPage = YES;
    AppDelegate *delegate = [AppDelegate sharedAppDelegate];
    [delegate enterMainPage];
}

- (void)tickDown:(NSTimer *)timer{
    [self enterMainPage];
}

#pragma mark - Delegate
-(void)finished{
    [self enterMainPage];
}

-(void)tapped{
    [self enterMainPage];
}

@end
