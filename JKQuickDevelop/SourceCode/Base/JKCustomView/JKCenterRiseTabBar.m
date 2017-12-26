//
//  JKCenterRiseTabBar.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/22.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKCenterRiseTabBar.h"
#import "UIView+JKFrame.h"

@interface JKCenterRiseTabBar ()
@property (nonatomic, strong) UIButton* centerRiseButton;
@end
@implementation JKCenterRiseTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.centerRiseButton = [[UIButton alloc] init];
    [self.centerRiseButton setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
    [self addSubview:self.centerRiseButton];
    [self.centerRiseButton addTarget:self action:@selector(centerRiseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label  = [[UILabel alloc] init];
    label.text      = @"发布";
    label.textColor = kDarkGrayColor;
    label.font      = [UIFont systemFontOfSize:12];
    [label sizeToFit];
    [self addSubview:label];
    
    self.centerRiseButton.jk_size    = self.centerRiseButton.currentBackgroundImage.size;
    self.centerRiseButton.jk_centerX = self.jk_width * 0.5;
    self.centerRiseButton.jk_centerY = 0;
    
    label.jk_centerX = self.centerRiseButton.jk_centerX;
    label.jk_centerY = self.centerRiseButton.jk_centerY + self.centerRiseButton.jk_height * 0.7;
    
    //设置其他按钮位置
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0, j = 0; i < count; i++) {
        UIView *child = self.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.jk_width = self.jk_width / 5.0;
            child.jk_left  = self.jk_width * j / 5.0;
            j++;
            if (j == 2) {
                j++;
            }
        }
    }
}

-(void)centerRiseButtonClick:(UIButton *)btn
{
    if ([self.jk_delegate respondsToSelector:@selector(centerRiseButtonClick:)]) {
        [self.jk_delegate centerRiseButtonClick:self];
    }
}

#pragma mark - Private methods

/// 使中间按钮能接收到完整的事件
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.isHidden){
        return nil;
    }
    
    CGPoint newPoint = [self convertPoint:point toView:self.centerRiseButton];
    if([self.centerRiseButton pointInside:newPoint withEvent:event]){
        return self.centerRiseButton;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

@end
