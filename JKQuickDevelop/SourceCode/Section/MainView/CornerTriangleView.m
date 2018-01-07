//
//  CornerTriangleView.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "CornerTriangleView.h"

@implementation CornerTriangleView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = @"title";
        self.titleFont = [UIFont systemFontOfSize:12];
        self.triangleColor = [UIColor blueColor];
        self.titleColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     andTitle:(NSString *)title
                 andTitleFont:(UIFont *)titleFont
                andTitleColor:(UIColor *)titleColor
             andTriangleColor:(UIColor *)triangleColor{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _titleFont = titleFont;
        _titleColor = titleColor;
        _triangleColor = triangleColor;
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor clearColor];
}


- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self setNeedsDisplay];
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    [self setNeedsDisplay];
}

- (void)setTriangleColor:(UIColor *)triangleColor{
    _triangleColor = triangleColor;
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(con, 0, 0);
    CGContextAddLineToPoint(con, w, 0);
    CGContextAddLineToPoint(con, 0, h);
    CGContextClosePath(con);
    [self.triangleColor setFill];
    CGContextDrawPath(con, kCGPathFill);
    
    CGRect rectText = CGRectMake(0, h / 7, 43.0 / 70.0 * w, 17.0 / 70.0 * h);
    if (self.title) {
        NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];
        NSTextAlignment align=NSTextAlignmentCenter;
        style.alignment= align;
        [self.title drawInRect:rectText withAttributes:@{NSFontAttributeName:self.titleFont,NSForegroundColorAttributeName:self.titleColor,NSParagraphStyleAttributeName:style}];
    }
}

@end
