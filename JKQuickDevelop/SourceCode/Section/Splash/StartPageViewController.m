//
//  StartPageViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/9.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "StartPageViewController.h"
#import "KeyValueUtility.h"
#import "LoginViewController.h"
#import "MainTabViewController.h"
#import "AppDelegate.h"

#define JKStartPageCount 4
@interface StartPageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *btnSkip;
@end

@implementation StartPageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - Overrite
-(void)configView{
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.btnSkip];
}

-(void)configData{
    for (int i = 0; i < JKStartPageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * JK_SCREEN_WIDTH, 0, JK_SCREEN_WIDTH, JK_SCREEN_HEIGHT)];
        NSString *path         = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"feature%d",i] ofType:@"png"];
        UIImage *image         = [UIImage imageWithContentsOfFile:path];
        imageView.image        = image;
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark - Public methods
+(BOOL)checkIfNeedStartPage{
    NSString *lastSkipVersion = [KeyValueUtility getValueForKey:JKLastAppVersion];
    NSString *localVersion    = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return ![lastSkipVersion isEqualToString:localVersion];
}

#pragma mark - Private methods;
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView                                = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled                  = YES;
        _scrollView.bounces                        = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize                    = CGSizeMake(JK_SCREEN_WIDTH * JKStartPageCount, JK_SCREEN_HEIGHT);
        _scrollView.delegate                       = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        CGFloat width              = JKStartPageCount * 15;
        _pageControl               = [[UIPageControl alloc] initWithFrame:CGRectMake((JK_SCREEN_WIDTH - width) / 2, JK_SCREEN_HEIGHT - 30, width, 10)];
        _pageControl.numberOfPages = JKStartPageCount;
    }
    return _pageControl;
}

- (UIButton *)btnSkip{
    if (!_btnSkip) {
        _btnSkip                     = [[UIButton alloc] initWithFrame:CGRectMake((JK_SCREEN_WIDTH - 60) / 2, JK_SCREEN_HEIGHT - 100, 60, 40)];
        [_btnSkip setTitle:LocalizedString(@"Skip") forState:UIControlStateNormal];
        _btnSkip.layer.cornerRadius  = 4;
        _btnSkip.layer.masksToBounds =YES;
        [_btnSkip addTarget:self action:@selector(skipStartPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSkip;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index =  roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.pageControl.currentPage = index;
    
    if(index == JKStartPageCount - 1){
        [self setVersionSkiped];
        [self enterNextController];
    }
}

/**
 跳过启动页
 */
- (void)skipStartPage:(UIButton *)sender{
    [self setVersionSkiped];
    [self enterNextController];
}

/**
 设置跳过此版本
 */
- (void)setVersionSkiped{
    NSString *localVersion    = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [KeyValueUtility setValue:localVersion forKey:JKLastAppVersion];
}

static BOOL isEntering = NO;

/**
 启动页结束进入下一个界面
 */
- (void)enterNextController{
    if (isEntering) {
        return;
    }
    isEntering = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AppDelegate sharedAppDelegate] enterMainPage];
    });
}

@end
