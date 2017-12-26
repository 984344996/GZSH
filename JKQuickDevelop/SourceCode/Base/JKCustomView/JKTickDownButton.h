//
//  JKTickDownButton.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/16.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKTickDownButtonDelegate <NSObject>
- (void)finished;
- (void)tapped;
@end

@interface JKTickDownButton : UIView

/**
 事件代理
 */
@property (nonatomic, weak)  id<JKTickDownButtonDelegate> delegate;


/**
 初始化函数
 */
- (instancetype)init:(CGRect)frame time:(double)time;

/**
 开始计时
 */
- (void)start;


/**
 停止计时
 */
- (void)stop;
@end
