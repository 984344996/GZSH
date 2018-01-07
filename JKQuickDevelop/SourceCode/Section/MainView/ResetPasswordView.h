//
//  ResetPasswordView.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/3.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordView : UIView

@property (nonatomic, strong) UITextField *inputPhone;
@property (nonatomic, strong) UITextField *inputSms;
@property (nonatomic, strong) UITextField *inputPass;
@property (nonatomic, strong) UIButton *buttonSms;
@property (nonatomic, strong) UIButton *buttonModify;


@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;

@end
