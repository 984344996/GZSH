//
//  MyCompanyInfoViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MyCompanyInfoViewController.h"
#import "MyCompanyInfoEditViewController.h"
#import "RichMode.h"
#import "UserInfo.h"
#import <MyLayout.h>
#import "NSString+Commen.h"
#import <MJExtension.h>
#import "APIServerSdk.h"
#import "AppDataFlowHelper.h"
#import <UIImageView+WebCache.h>

@interface MyCompanyInfoViewController ()
@property (nonatomic, strong) MyLinearLayout *rootLiner;
@property (nonatomic, strong) MyLinearLayout *linerCompanyInfo;
@property (nonatomic, strong) MyLinearLayout *linerCompanyService;

@property (nonatomic, strong) UILabel *labelPhone;
@property (nonatomic, strong) UILabel *labelMail;
@property (nonatomic, strong) UILabel *labelAddress;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) NSMutableArray *richInfoModels;
@property (nonatomic, strong) NSMutableArray *richServiceModels;
@property (nonatomic, strong) EnterpriseModel *enterpriseModel;
@end

@implementation MyCompanyInfoViewController

- (instancetype)initWithEnterpriseModel:(EnterpriseModel *)model isSelf:(BOOL)isSelf{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.isSelf = isSelf;
        self.enterpriseModel = model;
    }
    return self;
}

- (instancetype)initWithUserId:(NSString *)userId isSelf:(BOOL)isSelf{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.isSelf = isSelf;
        self.userId = userId;
    }
    return self;
}

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
    if (self.isSelf) {
        self.title = @"我的企业信息";
       [self addUIBarButtonItemText:@"编辑" isLeft:NO target:self action:@selector(editInfo:)];
    }else{
        self.title = @"企业资料";
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isSelf){
        [self loadEnterpriseInfo:nil];
    }
    if (self.enterpriseModel) {
        [self reloadUI];
    }
    if (self.userId) {
        [self loadEnterpriseInfo:self.userId];
    }
}

- (void)configData{
    [super configData];
}

- (void)reloadUI{
    self.richInfoModels = [RichMode mj_objectArrayWithKeyValuesArray:self.enterpriseModel.desc];
    self.richServiceModels = [RichMode mj_objectArrayWithKeyValuesArray:self.enterpriseModel.service];
    self.labelPhone.text = self.enterpriseModel.mobile;
    self.labelMail.text = self.enterpriseModel.email;
    self.labelAddress.text = self.enterpriseModel.address;
    [self.linerCompanyInfo removeAllSubviews];
    [self.linerCompanyService removeAllSubviews];
    
    for (RichMode *model in self.richInfoModels) {
        if ([model.type isEqualToString:@"image"]) {
            [self.linerCompanyInfo addSubview: [self addImageRich:model]];
        }else{
            [self.linerCompanyInfo addSubview: [self addLabelRich:model]];
        }
    }
    
    for (RichMode *model in self.richServiceModels) {
        if ([model.type isEqualToString:@"image"]) {
            [self.linerCompanyService addSubview: [self addImageRich:model]];
        }else{
            [self.linerCompanyService addSubview: [self addLabelRich:model]];
        }
    }
}

#pragma mark - APIServer
- (void)loadEnterpriseInfo:(NSString *)userId{
    NSString *loadId;
    if (!userId) {
        loadId = [AppDataFlowHelper getLoginUserInfo].userId;
    }else{
        loadId = userId;
    }
    
    WEAKSELF
    [APIServerSdk doGetUserInfo:loadId needCache:NO cacheSucceed:nil succeed:^(id obj) {
        STRONGSELF
        UserInfo *userInfo         = [UserInfo mj_objectWithKeyValues:obj];
        strongSelf.enterpriseModel = userInfo.enterprise;
        [strongSelf reloadUI];
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] tipMessage:@"加载数据失败" inView:strongSelf.view];
    }];
}

#pragma mark - Lazy loading

- (NSMutableArray *)richInfoModels{
    if (!_richInfoModels) {
        _richInfoModels = [NSMutableArray array];
    }
    return _richInfoModels;
}

- (NSMutableArray *)richServiceModels{
    if (!_richServiceModels) {
        _richServiceModels = [NSMutableArray array];
    }
    return _richServiceModels;
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
    MyLinearLayout *contentLayout = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    contentLayout.wrapContentSize = YES;
    contentLayout.myTop           = 10;
    contentLayout.myLeft          = 10;
    contentLayout.myTrailing      = 10;
    
    [self.rootLiner addSubview:[self createTitleLabel:title]];
    [self.rootLiner addSubview:contentLayout];
    return contentLayout;
}

- (UILabel *)createLabelContentLiner:(NSString *)title{
    UILabel *contentLabel  = [self createContentLabel:@""];
    [self.rootLiner addSubview:[self createTitleLabel:title]];
    [self.rootLiner addSubview:contentLabel];
    return contentLabel;
}

- (UILabel*)createTitleLabel:(NSString*)title
{
    UILabel *sectionLabel        = [UILabel new];
    sectionLabel.text            = title;
    sectionLabel.font            = kMainTextFieldTextFontLarge;
    sectionLabel.textColor       = kSecondTextColor;
    sectionLabel.wrapContentSize = YES;
    sectionLabel.myTop           = 12;
    sectionLabel.myLeading = sectionLabel.myTrailing = 0;
    return sectionLabel;
}

- (UILabel*)createContentLabel:(NSString*)content
{
    UILabel *contentLabel        = [UILabel new];
    contentLabel.text            = content;
    contentLabel.font            = kMainTextFieldTextFontMiddle;
    contentLabel.textColor       = kMainTextColor;
    contentLabel.myTop           = 5;
    contentLabel.myLeading = contentLabel.myTrailing = 12;
    contentLabel.wrapContentSize = YES;
    return contentLabel;
}

- (UIImageView *)addImageRich:(RichMode *)model{
    CGFloat height = kRichCompanyInfoWidth * (model.height / model.width);
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.layer.masksToBounds = YES;
    imageView.image = model.image;
    if (model.imageUrl) {
        [imageView sd_setImageWithURL:GetImageUrl(model.imageUrl) placeholderImage:kPlaceHoderBannerImage];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.myTop = 10;
    imageView.myLeading = 2;
    imageView.myTrailing = 2;
    imageView.myHeight = height;
    return imageView;
}

- (UILabel*)addLabelRich:(RichMode *)model
{
    UILabel *contentLabel   = [UILabel new];
    contentLabel.text       = model.inputContent;
    contentLabel.font       = kMainTextFieldTextFontMiddle;
    contentLabel.textColor  = kMainTextColor;
    contentLabel.myTop = 10;
    contentLabel.myLeading  = 0;
    contentLabel.myTrailing = 0;
    contentLabel.wrapContentSize = YES;
    return contentLabel;
}

- (void)editInfo:(UIBarButtonItem *)sender{
    MyCompanyInfoEditViewController *vc = [[MyCompanyInfoEditViewController alloc] initWithEnterpriseModel:self.enterpriseModel];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

@end
