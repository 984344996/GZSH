//
//  JKTopBottomViewCoordinator.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/24.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKTopBottomViewCoordinator.h"
#import "UIView+JKFrame.h"

static const NSTimeInterval kCoordinatorAnimationTime = 0.2;
static const CGFloat kCoordinatorAllHideOffset = 100;
@interface JKTopBottomViewCoordinator()<UIScrollViewDelegate>{
    CGFloat _lastContentOffsetY;
    CGFloat _currentHidePercent;
    CGRect _topViewInitFrame;
    CGRect _bottomViewInitFrame;
    BOOL _isMonitoring;
    BOOL _isTouching;
}

@property (nonatomic, assign)CGFloat topHeightForCollapse;
@property (nonatomic, assign)CGFloat bottomHeightForCollapse;
@end

@implementation JKTopBottomViewCoordinator

#pragma mark - Getter and Setter
-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView           = scrollView;
    _lastContentOffsetY = scrollView.contentOffset.y;
}

- (void)setTopView:(UIView *)topView{
    if (topView) {
        _topView = topView;
        _topViewInitFrame = _topView.frame;
    }
}

- (void)setBottomView:(UIView *)bottomView{
    if (bottomView) {
        _bottomView = bottomView;
        _bottomViewInitFrame = bottomView.frame;
    }
}


-(CGFloat)topHeightForCollapse{
    if (_topHeightForCollapse > 0) {
        return _topHeightForCollapse;
    }
    
    if (_topView) {
        if ([_topView isKindOfClass:[UINavigationBar class]]) {
            return _topViewInitFrame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height - _topViewMinisedHeight;
        }else{
            return _topViewInitFrame.size.height - _topViewMinisedHeight;
        }
    }
    return 0;
}

- (CGFloat)bottomHeightForCollapse{
    if (_bottomHeightForCollapse) {
        return _bottomHeightForCollapse;
    }
    
    if (_bottomView) {
        return _bottomViewInitFrame.size.height;
    }
    return 0;
}

#pragma mark - Public methods
- (instancetype)init{
    if (self = [super init]){
        _isMonitoring = false;
        self.topViewMinisedHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return self;
}

- (void)startMonitoring{
    if ([self checkCoordinatorAvailabel]) {
        _isMonitoring = YES;
    }
}

- (void)stopMonitoring{
    _isMonitoring = NO;
    [self fullExpandViewsWithAnimation:YES];
}

- (void)fullExpandViewsWithAnimation:(BOOL)animation{
    UIEdgeInsets scrollInsets  = [self getFixedInsetsWithBottom:self.bottomHeightForCollapse];
    if (animation) {
        [UIView animateWithDuration:kCoordinatorAnimationTime animations:^{
            [self.topView setFrame:_topViewInitFrame];
            [self.scrollView setContentInset:scrollInsets];
            [self.bottomView setFrame:_bottomViewInitFrame];
        }];
    }else{
        [self.topView setFrame:_topViewInitFrame];
        [self.scrollView setContentInset:scrollInsets];
        [self.bottomView setFrame:_bottomViewInitFrame];
    }
}

- (void)fullHideViewsWithAnimation:(BOOL)animation{
    CGFloat topY             = _topViewInitFrame.origin.y  - self.topHeightForCollapse;
    CGFloat bottomY          = _bottomViewInitFrame.origin.y + self.bottomHeightForCollapse;
    UIEdgeInsets scrollInsets  = [self getFixedInsetsWithBottom:0];
    
    if (animation) {
        [self animateTopViewToY:topY];
        [self animateScrollViewInsetsTo:scrollInsets];
        [self animateBottomViewToY:bottomY];
    }else{
        [self.topView setJk_top:topY];
        [self.bottomView setJk_top:bottomY];
        [self.scrollView setContentInset:scrollInsets];
    }
}

#pragma mark - Private methods
- (void)updateTopViewSubviews:(CGFloat)alpha
{
    if (alpha > 1.0f) {
        alpha = 1.0f;
    } else if (alpha < 0.0f) {
        alpha = 0.0f;
    }
    
    self.topView.tintColor = [self.topView.tintColor colorWithAlphaComponent:alpha];
    
    if ([self.topView isKindOfClass:[UINavigationBar class]]) {
        UINavigationBar *navigationBar = (UINavigationBar *)self.topView;
        NSMutableDictionary *navigationBarTitleTextAttributes = [navigationBar.titleTextAttributes mutableCopy] ? : [NSMutableDictionary dictionary];
        UIColor *titleColor = navigationBarTitleTextAttributes[NSForegroundColorAttributeName] ? : [[UINavigationBar appearance] titleTextAttributes][NSForegroundColorAttributeName] ? : [UIColor blackColor];
        titleColor = [titleColor colorWithAlphaComponent:alpha];
        navigationBarTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
        navigationBar.titleTextAttributes = navigationBarTitleTextAttributes;
    }
}

- (UIEdgeInsets)getFixedInsetsWithBottom:(CGFloat)bottom{
    UIEdgeInsets insets  = _scrollView.contentInset;
    insets.bottom = bottom;
    return insets;
}

- (void)animateHidePercent:(CGFloat)percentAppend animate:(BOOL)animate{
    _currentHidePercent += percentAppend;
    if (_currentHidePercent > 1) {
        _currentHidePercent = 1;
    }else if(_currentHidePercent < 0){
        _currentHidePercent = 0;
    }
    [self updateTopViewSubviews: 1 - _currentHidePercent];
    
    CGFloat topY             = _topViewInitFrame.origin.y  - self.topHeightForCollapse * _currentHidePercent;
    CGFloat bottomY          = _bottomViewInitFrame.origin.y + self.bottomHeightForCollapse * _currentHidePercent;
    UIEdgeInsets scrollInsets  = [self getFixedInsetsWithBottom:self.bottomHeightForCollapse * (1 - _currentHidePercent)];
    
    if (animate) {
        [self animateTopViewToY:topY];
        [self animateScrollViewInsetsTo:scrollInsets];
        [self animateBottomViewToY:bottomY];
    }else{
        [self.topView setJk_top:topY];
        [self.scrollView setContentInset:scrollInsets];
        [self.bottomView setJk_top:bottomY];
    }
}

- (void)animateTopViewToY:(CGFloat)y{
    [UIView animateWithDuration:kCoordinatorAnimationTime animations:^{
        [self.topView setJk_top:y];
    }];
}

- (void)animateBottomViewToY:(CGFloat)y{
    [UIView animateWithDuration:kCoordinatorAnimationTime animations:^{
        [self.bottomView setJk_top:y];
    }];
}

- (void)animateScrollViewInsetsTo:(UIEdgeInsets)insets{
    [UIView animateWithDuration:kCoordinatorAnimationTime animations:^{
        [self.scrollView setContentInset:insets];
    }];
}


/**
 检测Coordinator是否能工作

 @return 是否可用
 */
- (BOOL)checkCoordinatorAvailabel{
    if (self.scrollView && (self.topView || self.bottomView)) {
        return YES;
    }
    return NO;
}

#pragma mark - Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(!_isMonitoring){
        return;
    }
    
    _isTouching = YES;
    _lastContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.frame.size.height > scrollView.contentSize.height) {
        return;
    }
    if (!_isMonitoring || !_isTouching) {
        return;
    }
    
    CGFloat cotentOffsetY = scrollView.contentOffset.y;
    CGFloat cotentOffsetDelta = cotentOffsetY - _lastContentOffsetY;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (cotentOffsetY <= -scrollView.contentInset.top) {
        _currentHidePercent = 0;
        [self fullExpandViewsWithAnimation:NO];
        return;
    }else if((cotentOffsetY + scrollHeight) >= scrollContentSizeHeight){
        _currentHidePercent = 1;
        [self fullHideViewsWithAnimation:NO];
        return;
    }else{
        CGFloat hidePercent = cotentOffsetDelta / kCoordinatorAllHideOffset;
        [self animateHidePercent:hidePercent animate:NO];
        _lastContentOffsetY = cotentOffsetY;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!_isMonitoring){
        return;
    }
    
    _isTouching = NO;
    if (_currentHidePercent > 0.5) {
        [self fullHideViewsWithAnimation:YES];
    }else{
        [self fullExpandViewsWithAnimation:YES];
    }
}

@end
