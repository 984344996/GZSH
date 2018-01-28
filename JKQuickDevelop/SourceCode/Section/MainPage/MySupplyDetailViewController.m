//
//  MySupplyDetailViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/25.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MySupplyDetailViewController.h"
#import "MySupplyAndDemandEditViewController.h"
#import "EnterpriseModel.h"
#import "RichMode.h"
#import "UserInfo.h"
#import <MyLayout.h>
#import "NSString+Commen.h"
#import <MJExtension.h>
#import "APIServerSdk.h"
#import "DemandInfo.h"
#import "NSDate+Common.h"
#import <UIImageView+WebCache.h>

@interface MySupplyDetailViewController ()

@property (nonatomic, strong) MyLinearLayout *rootLiner;
@property (nonatomic, strong) MyLinearLayout *linerContent;

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UILabel *labelUser;
@property (nonatomic, strong) UILabel *labelContact;
@property (nonatomic, strong) UILabel *labelPublisher;

@property (nonatomic, strong) NSMutableArray *richContents;
@end

@implementation MySupplyDetailViewController


- (instancetype)initWithDemand:(DemandInfo *)demand isSelf:(BOOL)isSelf{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.demand = demand;
        self.isSelf = isSelf;
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
    self.title = @"供求信息";
    [self addUIBarButtonItemText:@"编辑" isLeft:NO target:self action:@selector(editInfo:)];
    [self addViews];
    [self reloadUI];
}


- (MyLinearLayout *)linerContent{
    if (!_linerContent) {
        _linerContent = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
        _linerContent.myTop           = 20;
        _linerContent.wrapContentSize = YES;
        _linerContent.myLeading       = 0;
        _linerContent.myTrailing      = 0;
    }
    return _linerContent;
}

- (MyLinearLayout *)createLinerH{
    MyLinearLayout *linerContent = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    linerContent.myTop           = 4;
    linerContent.wrapContentSize = YES;
    linerContent.myLeading       = 0;
    linerContent.myTrailing      = 0;
    return linerContent;
}

- (NSMutableArray *)richContents{
    if (!_richContents) {
        _richContents = [NSMutableArray array];
    }
    return _richContents;
}

#pragma mark - Events

- (void)editInfo:(UIBarButtonItem *)sender{
    MySupplyAndDemandEditViewController *vc = [[MySupplyAndDemandEditViewController alloc] initWithDemandInfo:self.demand];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - Private methods

- (void)addViews{
    self.labelTitle     = [self createTitleLabel:@""];
    self.labelTime      = [self createSubTitleLabel:@""];
    self.labelTime.myLeft = 0;
    self.labelTime.myTop = 0;
    
    self.labelUser      = [self createSubTitleLabel:@""];
    self.labelUser.myLeft = 24;
    self.labelUser.myTop = 0;
    
    self.labelContact   = [self createSubTitleLabel:@""];
    self.labelPublisher = [self createSubTitleLabel:@""];

    [self.rootLiner addSubview:self.labelTitle];
    MyLinearLayout *h   = [self createLinerH];
    [h addSubview:self.labelTime];
    [h addSubview:self.labelUser];
    [self.rootLiner addSubview:h];
    [self.rootLiner addSubview:self.labelContact];
    [self.rootLiner addSubview:self.labelPublisher];
    [self.rootLiner addSubview:self.linerContent];
}

- (void)reloadUI{
    self.richContents = [RichMode mj_objectArrayWithKeyValuesArray:self.demand.content];
    NSString *dateStr      = [NSDate parseServerDateTimeToFormat:self.demand.time format:kTurnState6];
    self.labelTitle.text   = self.demand.title;
    self.labelTime.text    = [NSString stringWithFormat:@"发布时间：%@",dateStr];
    self.labelUser.text    = [NSString stringWithFormat:@"发布人：%@",self.demand.username];
    self.labelContact.text = [NSString stringWithFormat:@"联系方式：%@",self.demand.contact];
    self.labelPublisher.text = [NSString stringWithFormat:@"发布单位：%@",self.demand.publisher];
    for (RichMode *model in self.richContents) {
        if ([model.type isEqualToString:@"image"]) {
            [self.linerContent addSubview: [self addImageRich:model]];
        }else{
            [self.linerContent addSubview: [self addLabelRich:model]];
        }
    }
}

- (UILabel*)createTitleLabel:(NSString*)title
{
    UILabel *sectionLabel        = [UILabel new];
    sectionLabel.text            = title;
    sectionLabel.font            = kMainTextFieldTextFontLarge;
    sectionLabel.textColor       = kMainTextColor;
    sectionLabel.myLeading       = sectionLabel.myTrailing = 0;
    sectionLabel.myTop           = 12;
    sectionLabel.wrapContentHeight = YES;
    return sectionLabel;
}

- (UILabel*)createSubTitleLabel:(NSString*)title
{
    UILabel *sectionLabel        = [UILabel new];
    sectionLabel.text            = title;
    sectionLabel.font            = kMainTextFieldTextFontSmall;
    sectionLabel.textColor       = kSecondTextColor;
    sectionLabel.myLeading       = 0;
    sectionLabel.myTop           = 4;
    sectionLabel.wrapContentSize = YES;
    return sectionLabel;
}

- (UIImageView *)addImageRich:(RichMode *)model{
    CGFloat height = kRichSupplyDetailWidth * (model.height / model.width);
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.layer.masksToBounds = YES;
    imageView.image = model.image;
    if (model.imageUrl) {
        [imageView sd_setImageWithURL:GetImageUrl(model.imageUrl) placeholderImage:kPlaceHoderBannerImage];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.myTop = 10;
    imageView.myLeading = 10;
    imageView.myTrailing = 10;
    imageView.myHeight = height;
    return imageView;
}

- (UILabel*)addLabelRich:(RichMode *)model
{
    UILabel *contentLabel   = [UILabel new];
    contentLabel.text       = model.inputContent;
    contentLabel.font       = kMainTextFieldTextFontSmall;
    contentLabel.textColor  = kMainTextColor;
    contentLabel.myLeading  = 10;
    contentLabel.myTrailing = 10;
    contentLabel.myTop      = 10;
    contentLabel.wrapContentSize = YES;
    return contentLabel;
}

@end
