//
//  MomentHeaderView.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/8.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentHeaderView : UIView

@property (nonatomic, strong) UIImageView *imagePosterView;
@property (nonatomic, strong) UIImageView *imageAvtar;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *labelCommentName;
@property (nonatomic, strong) UILabel *labelCommentCount;

@end
