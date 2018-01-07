//
//  ApplicationStep3View.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKTextField_Padding.h"
#import "UITextView+Placeholder.h"

@interface ApplicationStep3View : UIView

@property (nonatomic, strong) UILabel *labelPhone;
@property (nonatomic, strong) UILabel *labelAppend;

@property (nonatomic, strong) JKTextField_Padding *inputPhone;
@property (nonatomic, strong) UITextView *inputAppend;

@property (nonatomic, strong) UIButton *btnNext;

@end
