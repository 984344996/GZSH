//
//  FeedbackViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UITextView+Placeholder.h"
#import <JKCategories.h>

@interface FeedbackViewController ()
@property (nonatomic, strong) UITextView *textContent;
@property (nonatomic, strong) UIButton *btnSubmit;
@end

@implementation FeedbackViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.title = @"意见反馈";
    [self.view addSubview:self.textContent];
    [self.view addSubview:self.btnSubmit];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGFloat w = self.view.jk_width;
    CGFloat h = self.view.jk_height;
    self.textContent.frame = CGRectMake(12, 25, w - 24, 200);
    CGFloat btnH = 56;
    if (kDevice_Is_iPhoneX) {
        btnH += kDeltaForIphoneX;
    }
    [self.btnSubmit setFrame:CGRectMake(0, h - btnH, w, btnH)];
}

#pragma mark - Lazy loading

- (UITextView *)textContent{
    if (!_textContent) {
        _textContent = [[UITextView alloc] init];
        _textContent.font = kMainTextFieldTextFontMiddle;
        _textContent.textColor = kMainTextColor;
        _textContent.layer.borderColor = kMainTextFieldBorderColor.CGColor;
        _textContent.layer.borderWidth = 1;
        _textContent.placeholder = @"请输入...";
        _textContent.placeholderLabel.font = kMainTextFieldTextFontMiddle;
    }
    return _textContent;
}

- (UIButton *)btnSubmit{
    if (!_btnSubmit) {
        _btnSubmit = [[UIButton alloc] init];
        _btnSubmit.titleLabel.font = kMainTextFieldTextFontBold16;
        [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:kDarkGrayColor forState:UIControlStateDisabled];
        [_btnSubmit jk_setBackgroundColor:kMainGreenColor forState:UIControlStateNormal];
        [_btnSubmit jk_setBackgroundColor:[kMainGreenColor jk_darkenColor:0.2] forState:UIControlStateHighlighted];
        [_btnSubmit jk_setBackgroundColor:kDarkGrayColor forState:UIControlStateDisabled];
    }
    return _btnSubmit;
}

@end
