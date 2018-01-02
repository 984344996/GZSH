//
//  JKTextField_Padding.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/12/29.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKTextField_Padding.h"

@implementation JKTextField_Padding

#pragma mark - Initalize

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _leftPadding = 0;
        _rightPadding = 0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andLeftPadding:(CGFloat)leftPadding andRightPadding:(CGFloat)rightPadding{
    self = [super initWithFrame:frame];
    if (self) {
        _leftPadding = leftPadding;
        _rightPadding = rightPadding;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _leftPadding = 0;
        _rightPadding = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder andLeftPadding:(CGFloat)leftPadding andRightPadding:(CGFloat)rightPadding{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _leftPadding = leftPadding;
        _rightPadding = rightPadding;
    }
    return self;
}

#pragma mark - Getter and Setter

- (void)setLeftPadding:(CGFloat)leftPadding{
    _leftPadding = leftPadding;
    [self setNeedsLayout];
}

- (void)setRightPadding:(CGFloat)rightPadding{
    _rightPadding = rightPadding;
    [self setNeedsLayout];
}

#pragma mark - Overrite

- (CGRect)boundRectWithPadding:(CGRect)bounds{
    CGFloat sX = bounds.origin.x + self.leftPadding;
    CGFloat sY = bounds.origin.y;
    CGFloat w  = bounds.size.width - self.leftPadding - self.rightPadding;
    CGFloat h  = bounds.size.height;
    return CGRectMake(sX, sY, w, h);
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return [self boundRectWithPadding:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return [self boundRectWithPadding:bounds];
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    return [self boundRectWithPadding:bounds];
}

- (void) prepareForInterfaceBuilder{
    [super prepareForInterfaceBuilder];
}
@end
