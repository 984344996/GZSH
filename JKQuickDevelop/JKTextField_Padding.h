//
//  JKTextField_Padding.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/12/29.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface JKTextField_Padding : UITextField

// text left padding
@property (nonatomic, assign)IBInspectable CGFloat leftPadding;
// text right padding
@property (nonatomic, assign)IBInspectable CGFloat rightPadding;

- (instancetype)initWithFrame:(CGRect)frame andLeftPadding:(CGFloat)leftPadding andRightPadding:(CGFloat)rightPadding;
- (instancetype)initWithCoder:(NSCoder *)aDecoder andLeftPadding:(CGFloat)leftPadding andRightPadding:(CGFloat)rightPadding;

@end
