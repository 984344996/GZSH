//
//  LoginView.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;

@property (weak, nonatomic) IBOutlet UITextField *textPass;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnResetPass;
@property (weak, nonatomic) IBOutlet UIButton *btnApplication;

@end
