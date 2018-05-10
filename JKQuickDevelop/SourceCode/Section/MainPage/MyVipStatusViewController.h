//
//  MyVipStatusViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "JKBaseViewController.h"

@interface MyVipStatusViewController : JKBaseViewController
@property (weak, nonatomic) IBOutlet UILabel            *labelCharm;
@property (weak, nonatomic) IBOutlet UIImageView        *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel            *labelTime;
@property (weak, nonatomic) IBOutlet UIButton           *buttonRenew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonHeight;

@end
