//
//  CornerTriangleView.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CornerTriangleView : UIView

@property (nonatomic, strong) UIColor *triangleColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont  *titleFont;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame
                     andTitle:(NSString *)title
                 andTitleFont:(UIFont *)titleFont
                andTitleColor:(UIColor *)titleColor
             andTriangleColor:(UIColor *)triangleColor;

@end
