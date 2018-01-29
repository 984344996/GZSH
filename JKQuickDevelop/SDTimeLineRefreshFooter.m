//
//  SDTimeLineRefreshFooter.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/3/6.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDTimeLineRefreshFooter.h"
#import "UIView+SDAutoLayout.h"

#define kSDTimeLineRefreshFooterHeight 50

@implementation SDTimeLineRefreshFooter{
    CFAbsoluteTime startTime;
}

+ (instancetype)refreshFooterWithRefreshingText:(NSString *)text
{
    SDTimeLineRefreshFooter *footer = [SDTimeLineRefreshFooter new];
    footer.indicatorLabel.text = text;
    return footer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)addToScrollView:(UIScrollView *)scrollView refreshOpration:(void (^)())refrsh
{
    startTime = CFAbsoluteTimeGetCurrent();
    self.scrollView = scrollView;
    self.refreshBlock = refrsh;
}

- (void)setupView
{
    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    
    self.indicatorLabel = [UILabel new];
    self.indicatorLabel.textColor = [UIColor lightGrayColor];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator startAnimating];
    [containerView sd_addSubviews:@[self.indicatorLabel, self.indicator]];
    
    containerView.sd_layout
    .heightIs(20)
    .centerYEqualToView(self)
    .centerXEqualToView(self);
    [containerView setupAutoWidthWithRightView:self.indicatorLabel rightMargin:0]; // 宽度自适应
    
    self.indicator.sd_layout
    .leftEqualToView(containerView)
    .topEqualToView(containerView); // ActivityIndicatorView 宽高固定不用约束
    
    self.indicatorLabel.sd_layout
    .leftSpaceToView(self.indicator, 5)
    .topEqualToView(containerView)
    .bottomEqualToView(containerView);
    [self.indicatorLabel setSingleLineAutoResizeWithMaxWidth:250]; // label宽度自适应
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    [super setScrollView:scrollView];
    [scrollView addSubview:self];
    self.hidden = YES;
}

- (void)endRefreshing
{
    // 每次完成加载更新下时间
    startTime = CFAbsoluteTimeGetCurrent();
    [super endRefreshing];
    [self setHidden:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentInset = self.scrollViewOriginalInsets;
    }];
}

- (void)endRefreshingWithNoMoreData{
    [self setHidden:NO];
    [self.indicator setHidden:YES];
    self.indicatorLabel.text = @"没有更多数据...";
    self.refreshState = SDWXRefreshViewStateNoMoreData;
}

- (void)resetNoMoreData{
    [self endRefreshing];
    [self.indicator setHidden:NO];
    self.indicatorLabel.text = @"正在加载数据...";
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    if (self.refreshState == SDWXRefreshViewStateNoMoreData) {
        [self.indicator setHidden:YES];
    }
}

- (void)setRefreshState:(SDWXRefreshViewState)refreshState
{
    [super setRefreshState:refreshState];
    
    if (refreshState == SDWXRefreshViewStateRefreshing) {
        self.scrollViewOriginalInsets = self.scrollView.contentInset;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.bottom += kSDTimeLineRefreshFooterHeight;
        self.scrollView.contentInset = insets;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.refreshState == SDWXRefreshViewStateNoMoreData) {
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.width_sd, kSDTimeLineRefreshFooterHeight);
        return;
    }
    if (keyPath != kSDBaseRefreshViewObserveKeyPath) return;
    CGFloat offsetY      = self.scrollView.contentOffset.y;
    CGFloat height       = self.scrollView.height_sd;
    CGFloat contentY     = self.scrollView.contentSize.height;
    CGFloat bottomInsetY = self.scrollViewOriginalInsets.bottom;
    CGFloat topInsetY    = self.scrollViewOriginalInsets.bottom;

    if (@available(iOS 11.0, *)) {
        topInsetY            = self.scrollView.safeAreaInsets.top;
        bottomInsetY         = self.scrollView.safeAreaInsets.bottom;
    }
    
    BOOL compare1 = (offsetY > contentY - height + bottomInsetY + 20);
    BOOL compare2 = (contentY + topInsetY +bottomInsetY > height);
    BOOL compare3 = ((CFAbsoluteTimeGetCurrent() - startTime) > 2);
    
    if (self.refreshState != SDWXRefreshViewStateRefreshing && compare1 && compare2 && compare3) {
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.width_sd, kSDTimeLineRefreshFooterHeight);
        self.hidden = NO;
        self.refreshState = SDWXRefreshViewStateRefreshing;
    } else if (self.refreshState == SDWXRefreshViewStateNormal) {
        self.hidden = YES;
    }
}


@end
