//
//  JKTickDownButton.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/2/16.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKTickDownButton.h"

@interface JKTickDownButton (){
    double _timeToTick;
    double _tickerNow;
    double _angleBorder;
    
    CGFloat _borderWidth;
    CGFloat _innerPadding;
    
    UIColor *_innerColor;
    UIColor *_borderColor;
    UIColor *_textColor;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *label;
@end

@implementation JKTickDownButton

- (instancetype)init:(CGRect)frame time:(double)time{
    if (self  = [super initWithFrame:frame]){
        _timeToTick = time;
        [self initParams];
        [self initView];
    }
    return self;
}


#pragma mark - Public methods
- (void)start{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tickDown:) userInfo:nil repeats:YES];
    }
}

- (void)stop{
    [self.timer invalidate];
    self.timer = nil;
    _tickerNow = 0;
    _angleBorder = 0;
    [self setNeedsDisplay];
}


#pragma mark - Private methods
- (void)initParams{
    _borderWidth = 3;
    _innerPadding = 5;
    
    _innerColor = RGBA(0, 0, 0, 0.4);
    _borderColor = [UIColor whiteColor];
    _textColor = [UIColor whiteColor];
}

- (void)initView{
    self.userInteractionEnabled = YES;
    self.backgroundColor        = [UIColor clearColor];
    // 跳过
    self.label               = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.font          = [UIFont systemFontOfSize:11];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor     = [UIColor whiteColor];
    self.label.text          = LocalizedString(@"Skip");
    [self addSubview:self.label];
}

- (void)tickDown:(NSTimer *)timer{
    _tickerNow   += 0.1;
    if (_timeToTick - _tickerNow <=0) {
        [self.timer invalidate];
    self.timer   = nil;

    _angleBorder = 2 * M_PI;
        [self.delegate finished];
    }else{
    _angleBorder = 2 * M_PI * (_tickerNow / _timeToTick);
    }
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.timer invalidate];
    self.timer = nil;
    [self.delegate tapped];
}

/**
 绘制计时器
 */
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGFloat width        = rect.size.width;
    CGFloat height       = rect.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _innerColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectInset(rect, _borderWidth + _innerPadding, _borderWidth + _innerPadding));
    CGContextFillPath(context);

    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);

    CGContextAddArc(context, width / 2, height / 2, (width - _borderWidth) / 2 - _innerPadding, (CGFloat)(-M_PI_2), (CGFloat)(_angleBorder) + (CGFloat)(-M_PI_2), YES);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _borderWidth);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
