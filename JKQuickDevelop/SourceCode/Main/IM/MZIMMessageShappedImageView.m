//
//  MZIMMessageShappedImageView.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/21.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessageShappedImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MZIMMessageShappedImageView
-(void)setImage:(UIImage *)image{
    _image = image;
    [self setNeedsDisplay];
}

- (void)setIsComing:(BOOL *)isComing{
    _isComing = isComing;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self.image drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width        = rect.size.width;
    CGFloat height       = rect.size.height;
    
    CGContextSaveGState(context);
    ///第一条边
    CGContextMoveToPoint(context, kShappedMargin + kShappedRadius, kShappedRadius);
    CGContextAddLineToPoint(context, width - kShappedMargin - kShappedRadius, kShappedMargin);
    ///右上角圆弧
    CGContextAddArc(context,  width - kShappedMargin - kShappedRadius, kShappedMargin + kShappedRadius, kShappedRadius, -M_PI_2, 0, false);
    ///右边三角开始
    CGContextAddLineToPoint(context, width - kShappedMargin, kShappedMargin + kShappedRadius + kShappedMarginTop);
    
    if (self.isComing) {
        CGFloat triangStartX    = width - kShappedTopSize;
        CGFloat triangStartY    = kShappedMargin + kShappedRadius + kShappedMarginTop + (kShappedTringleSize - (kShappedTopSize / kShappedMargin * kShappedTringleSize)) / 2;
        CGFloat tempLineLength  = powf(kShappedTopSize / kShappedMargin * kShappedTringleSize / 2, 2) / kShappedTopSize;
        CGFloat triangleRadus   = sqrt(powf(tempLineLength, 2) +  powf((kShappedTopSize / kShappedMargin * kShappedTringleSize / 2), 2));
        double triangleAngle    = asin((kShappedTopSize / kShappedMargin * kShappedTringleSize / 2)/triangleRadus);
        CGFloat triangleCenterX = width - kShappedTopSize - tempLineLength;
        CGFloat trangleCenterY  = kShappedMargin + kShappedRadius + kShappedMarginTop + kShappedTringleSize / 2;

        CGContextAddLineToPoint(context, triangStartX, triangStartY);
        CGContextAddArc(context, triangleCenterX, trangleCenterY, triangleRadus, -triangleAngle, triangleAngle, false);
        CGContextAddLineToPoint(context, width - kShappedMargin, kShappedMargin + kShappedRadius + kShappedTringleSize + kShappedMarginTop);
    }
    
    CGContextAddLineToPoint(context, width - kShappedMargin, height - kShappedMargin - kShappedRadius);
    CGContextAddArc(context, width - kShappedMargin - kShappedRadius, height - kShappedMargin - kShappedRadius, kShappedRadius, 0, M_PI_2, false);
    
    CGContextAddLineToPoint(context, kShappedRadius + kShappedMargin, height - kShappedMargin);
    CGContextAddArc(context, kShappedMargin + kShappedRadius, height - kShappedMargin - kShappedRadius, kShappedRadius, M_PI_2, M_PI, false);
    CGContextAddLineToPoint(context, kShappedMargin, kShappedMargin + kShappedRadius + kShappedTringleSize + kShappedMarginTop);
    
    if (!self.isComing) {
        CGFloat triangStartX    = kShappedTopSize;
        CGFloat triangStartY    = kShappedMargin  +  kShappedRadius + kShappedMarginTop + kShappedTringleSize / 2 +(kShappedTringleSize - (kShappedTopSize / kShappedMargin * kShappedTringleSize)) / 2;
        CGFloat tempLineLength  = powf(kShappedTopSize / kShappedMargin * kShappedTringleSize / 2, 2) / kShappedTopSize;
        CGFloat triangleRadus   = sqrt(powf(tempLineLength, 2) +  powf((kShappedTopSize / kShappedMargin * kShappedTringleSize / 2), 2));
        double triangleAngle    = asin((kShappedTopSize / kShappedMargin * kShappedTringleSize / 2) / triangleRadus);
        CGFloat triangleCenterX = kShappedTopSize + tempLineLength;
        CGFloat trangleCenterY  = kShappedMargin + kShappedRadius + kShappedMarginTop + kShappedTringleSize / 2;

        CGContextAddLineToPoint(context, triangStartX, triangStartY);
        CGContextAddArc(context, triangleCenterX, trangleCenterY, triangleRadus, M_PI - triangleAngle, M_PI + triangleAngle, false);
        CGContextAddLineToPoint(context, kShappedMargin, kShappedMargin + kShappedRadius  + kShappedMarginTop);
    }
    
    CGContextAddLineToPoint(context, kShappedMargin, kShappedMargin + kShappedRadius);
    CGContextAddArc(context, kShappedMargin + kShappedRadius, kShappedMargin + kShappedRadius, kShappedRadius, M_PI, M_PI_2 * 3, false);
    
    CGContextAddRect(context, rect);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextDrawPath(context, kCGPathEOFill);
    CGContextRestoreGState(context);
}

@end
