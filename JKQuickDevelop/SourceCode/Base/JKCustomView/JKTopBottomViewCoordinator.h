//
//  JKTopBottomViewCoordinator.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/24.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKTopBottomViewCoordinatorDelegate <NSObject>
@optional
@end

@interface JKTopBottomViewCoordinator : NSObject
/** 滚动区域上方View */
@property (nonatomic, strong) UIView* topView;

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 滚动视图下方View */
@property (nonatomic, strong) UIView *bottomView;


/** 上方留下的最小大小 */
@property (nonatomic, assign) CGFloat topViewMinisedHeight;

/**
 开始监控UIScrollView滚动
 */
- (void)startMonitoring;


/**
 停止监控UIScrollView滚动
 */
- (void)stopMonitoring;


/**
 恢复初始设置
 */
- (void)fullExpandViewsWithAnimation:(BOOL)animation;
- (void)fullHideViewsWithAnimation:(BOOL)animation;

/** 要实现联动必须重写UIScrollViewDelegate以下方法 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
