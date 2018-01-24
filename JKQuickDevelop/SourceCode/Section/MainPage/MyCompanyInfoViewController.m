//
//  MyCompanyInfoViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MyCompanyInfoViewController.h"
#import "MyCompanyInfoEditViewController.h"
#import "EnterpriseModel.h"
#import "RichMode.h"
#import <MyLayout.h>
#import "NSString+Commen.h"
#import <MJExtension.h>

@interface MyCompanyInfoViewController ()
@property (nonatomic, strong) MyLinearLayout *rootLiner;
@property (nonatomic, strong) MyLinearLayout *linerCompanyInfo;
@property (nonatomic, strong) MyLinearLayout *linerCompanyService;

@property (nonatomic, strong) UILabel *labelPhone;
@property (nonatomic, strong) UILabel *labelMail;
@property (nonatomic, strong) UILabel *labelAddress;
@end

@implementation MyCompanyInfoViewController

#pragma mark - Life circle

- (void)loadView{
    UIScrollView *scrollView   = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view                  = scrollView;
    _rootLiner                 = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _rootLiner.padding         = UIEdgeInsetsMake(12, 12, 12, 12);
    _rootLiner.myLeading       = _rootLiner.myTrailing = 0;
    _rootLiner.heightSize.lBound(scrollView.heightSize, 10, 1);
    [scrollView addSubview:_rootLiner];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    [self configLiner];
    self.title = @"我的企业信息";
    [self addUIBarButtonItemText:@"编辑" isLeft:NO target:self action:@selector(editInfo:)];
}


- (void)configData{
    [super configData];
    
}

#pragma mark - APIServer

- (void)loadEnterpriseInfo{
    
}


#pragma mark - UI Create

- (void)configLiner{
    self.linerCompanyInfo    = [self createRichContentLiner:@"企业概况："];
    self.linerCompanyService = [self createRichContentLiner:@"企业服务："];
    self.labelPhone          = [self createLabelContentLiner:@"电话号码："];
    self.labelMail           = [self createLabelContentLiner:@"邮箱："];
    self.labelAddress        = [self createLabelContentLiner:@"地址："];
}


- (MyLinearLayout *)createRichContentLiner:(NSString *)title{
    MyLinearLayout *layout        = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    layout.myLeading              = layout.myTrailing = 0;
    layout.myTop                  = 25;
    layout.heightSize.min(25);
    layout.wrapContentSize        = YES;
    
    MyLinearLayout *contentLayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    contentLayout.weight          = 1;
    contentLayout.wrapContentSize = YES;
    contentLayout.myLeft          = 12;
    contentLayout.myTrailing      = 0;
    
    [layout addSubview:[self createTitleLabel:title]];
    [layout addSubview:contentLayout];
    [self.rootLiner addSubview:layout];
    return contentLayout;
}

- (UILabel *)createLabelContentLiner:(NSString *)title{
    MyLinearLayout *layout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    layout.myLeading       = layout.myTrailing = 0;
    layout.myTop           = 25;
    layout.heightSize.min(25);
    layout.wrapContentSize = YES;

    UILabel *contentLabel  = [self createContentLabel:@""];
    [layout addSubview:[self createTitleLabel:title]];
    [layout addSubview:contentLabel];
    [self.rootLiner addSubview:layout];
    return contentLabel;
}

- (UILabel*)createTitleLabel:(NSString*)title
{
    UILabel *sectionLabel        = [UILabel new];
    sectionLabel.text            = title;
    sectionLabel.font            = kMainTextFieldTextFontMiddle;
    sectionLabel.textColor       = kSecondTextColor;
    sectionLabel.myWidth         = 80;
    sectionLabel.myHeight        = 25;
    sectionLabel.myLeading       = sectionLabel.myTop = 0;
    sectionLabel.textAlignment   = NSTextAlignmentRight;
    return sectionLabel;
}

- (UILabel*)createContentLabel:(NSString*)content
{
    UILabel *contentLabel        = [UILabel new];
    contentLabel.text            = content;
    contentLabel.font            = kMainTextFieldTextFontMiddle;
    contentLabel.textColor       = kMainTextColor;
    contentLabel.myLeft          = 12;
    contentLabel.weight          = 1;
    contentLabel.wrapContentSize = YES;
    return contentLabel;
}

- (UIImageView *)addImageRich:(RichMode *)model{
    CGFloat height = kRichCompanyInfoWidth * (model.height / model.width);
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.layer.masksToBounds = YES;
    imageView.image = model.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.myTop = 0;
    imageView.myLeading = 2;
    imageView.myTrailing = 2;
    imageView.myHeight = height;
    return imageView;
}

- (UILabel*)addContentLabel:(NSString*)content
{
    UILabel *contentLabel   = [UILabel new];
    contentLabel.text       = content;
    contentLabel.font       = kMainTextFieldTextFontMiddle;
    contentLabel.textColor  = kMainTextColor;
    contentLabel.myLeading  = 0;
    contentLabel.myTrailing = 0;
    contentLabel.wrapContentSize = YES;
    return contentLabel;
}

- (void)editInfo:(UIBarButtonItem *)sender{
    MyCompanyInfoEditViewController *vc = [[MyCompanyInfoEditViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

@end
