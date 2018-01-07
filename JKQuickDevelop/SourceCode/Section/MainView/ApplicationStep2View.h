//
//  ApplicationStep2View.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/4.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKTextField_Padding.h"
#import "UITextView+Placeholder.h"

@interface ApplicationStep2View : UIView

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) UIButton *btnImage;
@property (nonatomic, strong) UIButton *btnReupload;
@property (nonatomic, strong) UIButton *btnNext;

@property (nonatomic, strong) JKTextField_Padding *inputName;
@property (nonatomic, strong) UILabel *inputAddressProvince;
@property (nonatomic, strong) UILabel *inputAddressCity;
@property (nonatomic, strong) JKTextField_Padding *inputCompany;
@property (nonatomic, strong) JKTextField_Padding *inpputCompayPosition;
@property (nonatomic, strong) UITextView *inputCompanyInfo;

@property (nonatomic, strong) UILabel *labelImage;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelAddress;
@property (nonatomic, strong) UILabel *labelCompay;
@property (nonatomic, strong) UILabel *labelCompayPosition;
@property (nonatomic, strong) UILabel *labelCompayInfo;

@end
