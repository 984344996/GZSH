//
//  MySupplyAndDemandEditViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MySupplyAndDemandEditViewController.h"
#import <MyLayout.h>
#import "UITextView+Placeholder.h"
#import "JKTextField_Padding.h"
#import <IQKeyboardManager.h>
#import "RichMode.h"
#import "NSString+Commen.h"
#import <ZLPhotoActionSheet.h>
#import <ReactiveObjC.h>
#import "HUDHelper.h"
#import "EnterpriseModel.h"
#import "UploadRichEngine.h"
#import <MJExtension.h>
#import "APIServerSdk.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "DemandInfo.h"
#import <UIImageView+WebCache.h>

@interface MySupplyAndDemandEditViewController ()<UITextViewDelegate>

@property (nonatomic, strong) ZLPhotoActionSheet* photoActionSheet;
@property (nonatomic, strong) MyLinearLayout *rootLiner;
@property (nonatomic, strong) MyLinearLayout *linerContent;
@property (nonatomic, strong) NSMutableArray *supplyRich;
@property (nonatomic, assign) NSUInteger currentEdit;

@property (nonatomic, strong) JKTextField_Padding *inputTitle;
@property (nonatomic, strong) JKTextField_Padding *inputCompany;
@property (nonatomic, strong) JKTextField_Padding *inputPhone;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, strong) DemandInfo *demandInfo;
@end

@implementation MySupplyAndDemandEditViewController

- (instancetype)initWithDemandInfo:(DemandInfo *)model;{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (model) {
            self.demandInfo    = model;
            self.supplyRich    = [RichMode mj_objectArrayWithKeyValuesArray:self.demandInfo.content];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)loadView{
    _currentEdit = -1;
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    _rootLiner = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _rootLiner.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    _rootLiner.myLeading = _rootLiner.myTrailing = 0;
    _rootLiner.heightSize.lBound(scrollView.heightSize, 10, 1);
    [scrollView addSubview:_rootLiner];
}


- (void)configView{
    [super configView];
    self.title = @"编辑供求信息";
    UIBarButtonItem *itemPic = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:UIBarButtonItemStylePlain target:self action:@selector(insertPic:)];
    UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(editDone:)];
    self.navigationItem.rightBarButtonItems = @[itemDone,itemPic];
    
    [self configLiner];
    [self reloadContentInfo];
}

- (void)configEvent{
    [super configEvent];
    RAC(self.demandInfo , title) = [RACSignal merge:@[RACObserve(self.inputTitle, text),self.inputTitle.rac_textSignal]];
    RAC(self.demandInfo , publisher) = [RACSignal merge:@[RACObserve(self.inputCompany, text),self.inputCompany.rac_textSignal]];
    RAC(self.demandInfo , contact) = [RACSignal merge:@[RACObserve(self.inputPhone, text),self.inputPhone.rac_textSignal]];
}

- (void)configLiner{
    _inputTitle = [self makeLinerTitleWithInput:@"标题:" placeHolder:@"请输入..."];
    _inputCompany = [self makeLinerTitleWithInput:@"发布单位:" placeHolder:@"请输入..."];
    _inputPhone = [self makeLinerTitleWithInput:@"联系方式:" placeHolder:@"请输入..."];
    _linerContent = [self makeLinerContent:@"内容:"];
    
    self.inputTitle.text = self.demandInfo.title;
    self.inputCompany.text = self.demandInfo.publisher;
    self.inputPhone.text = self.demandInfo.contact;
}

#pragma mark - Lazy loading

- (UIWindow *)window{
    if (!_window) {
        _window = [[AppDelegate sharedAppDelegate] window];
    }
    return _window;
}

- (DemandInfo *)demandInfo{
    if (!_demandInfo) {
        _demandInfo = [[DemandInfo alloc] init];
    }
    return _demandInfo;
}

- (NSMutableArray *)supplyRich{
    if (!_supplyRich) {
        _supplyRich = [NSMutableArray array];
    }
    return _supplyRich;
}

- (ZLPhotoActionSheet *)photoActionSheet{
    if (!_photoActionSheet) {
        _photoActionSheet = [[ZLPhotoActionSheet alloc] init];
        _photoActionSheet.sender = self;
        _photoActionSheet.configuration.navBarColor = kGreenColor;
        _photoActionSheet.configuration.navTitleColor = kWhiteColor;
        _photoActionSheet.configuration.maxSelectCount = 1;
        _photoActionSheet.configuration.allowSelectGif = NO;
        _photoActionSheet.configuration.allowSelectVideo = NO;
        _photoActionSheet.configuration.allowMixSelect = NO;
        _photoActionSheet.configuration.allowEditImage = YES;
        _photoActionSheet.configuration.allowSelectOriginal = NO;
    }
    return _photoActionSheet;
}

#pragma mark - Private methods

- (void)reloadContentInfo{
    [self.linerContent removeAllSubviews];
    [self.supplyRich enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RichMode *model = obj;
        model.tagForView = viewTagNow++;
        if ([model.type isEqualToString:@"text"]){
            UITextView *textView = [self createTextViewRich:model];
            CGFloat h            = [textView sizeThatFits:CGSizeMake(kRichSupplyWidth, CGFLOAT_MAX)].height;
            textView.myHeight    = h;
            [self.linerContent addSubview:textView];
        }else{
            UIImageView *imageView = [self createImageRich:model];
            [self.linerContent addSubview:imageView];
        }
    }];
}

- (UITextView *)createTextViewRich:(RichMode *)model{
    UITextView  *textView = [[UITextView alloc] init];
    textView.tag = model.tagForView;
    
    WEAKSELF
    textView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
    textView.delegate = weakSelf;
    textView.scrollEnabled = NO;
    textView.text = model.inputContent;
    textView.font = kMainTextFieldTextFontMiddle;
    textView.textColor = kMainTextColor;
    textView.placeholder = @"请输入...";
    textView.placeholderLabel.font = kMainTextFieldTextFontMiddle;
    textView.myHeight = 30;
    textView.myTop = 0;
    textView.myLeading = 0;
    textView.myTrailing = 0;
    return textView;
}

- (UIImageView *)createImageRich:(RichMode *)model{
    CGFloat height = kRichSupplyWidth * (model.height / model.width);
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.tag = model.tagForView;
    imageView.layer.masksToBounds = YES;
    imageView.image = model.image;
    if (model.imageUrl) {
        [imageView sd_setImageWithURL:GetImageUrl(model.imageUrl) placeholderImage:kPlaceHoderBannerImage];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.myTop = 0;
    imageView.myLeading = 2;
    imageView.myTrailing = 2;
    imageView.myHeight = height;
    imageView.userInteractionEnabled = YES;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"AlbumCancel"]
            forState:UIControlStateNormal];
    
    WEAKSELF
    [button addTarget:weakSelf action:@selector(imageDel:) forControlEvents:UIControlEventTouchUpInside];
    button.useFrame = YES;
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    [imageView addSubview:button];
    
    return imageView;
}

- (void)addPic:(UIImage *)image{
    RichMode *newRich = [self createImageRichModel:image];
    UIImageView *imageView = [self createImageRich:newRich];
    /// 筛选前面添加的View  如果文字不为空则插入
    if (self.currentEdit == 1) {
        /// 最后一个是否为空
        RichMode *lastModel = [self.supplyRich lastObject];
        UITextView *lastText = [self.view viewWithTag:lastModel.tagForView];
        if ([NSString isEmpty:lastText.text]) {
            [self.linerContent insertSubview:imageView atIndex:self.linerContent.subviews.count - 1];
            [self.supplyRich insertObject:newRich atIndex:self.supplyRich.count - 1];
            [lastText becomeFirstResponder];
        }else{
            RichMode *newTextModel=  [self createBlankTextRich];
            UITextView *textView = [self createTextViewRich:newTextModel];
            [self.linerContent addSubview:imageView];
            [self.linerContent addSubview:textView];
            [self.supplyRich addObject:newRich];
            [self.supplyRich addObject:newTextModel];
            [textView becomeFirstResponder];
        }
    }
}

- (BOOL)checkForSubmit{
    NSString *tipMsg;
    BOOL isSucceed = YES;
    
    if ([NSString isEmpty:self.demandInfo.title] && isSucceed) {
        tipMsg = @"标题不能为空";
        isSucceed = NO;
    }
    if ([NSString isEmpty:self.demandInfo.publisher] && isSucceed) {
        tipMsg = @"企业不能为空";
        isSucceed = NO;
    }
    
    if ([NSString isEmpty:self.demandInfo.contact] && isSucceed) {
        tipMsg = @"联系方式不能为空";
        isSucceed = NO;
    }
    
    if (![self checkForCotentRich:self.supplyRich] && isSucceed) {
        tipMsg = @"内容不能为空";
        isSucceed = NO;
    }
    
    if (!isSucceed) {
        [[HUDHelper sharedInstance] tipMessage:tipMsg inView:self.view];
    }
    return isSucceed;
}

- (BOOL)checkForCotentRich:(NSMutableArray *)richs{
    if (richs.count == 1) {
        RichMode *mode = richs[0];
        UITextView *textView = [self.view viewWithTag:mode.tagForView];
        if ([NSString isEmpty:textView.text]) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - Events

- (void)insertPic:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    WEAKSELF
    [self.photoActionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        STRONGSELF
        UIImage *image = images[0];
        if (image) {
            [strongSelf addPic:image];
        }
    }];
    [self.photoActionSheet showPreviewAnimated:YES];
    
}

- (void)editDone:(UIBarButtonItem *)sender{
    if ([self checkForSubmit]) {
        self.hud = [[HUDHelper sharedInstance] loading:@"更新中" inView:self.window];
        WEAKSELF
        [[UploadRichEngine sharedInstance] upLoadRiches:self.supplyRich succeed:^(NSMutableArray *riches) {
            STRONGSELF
            strongSelf.supplyRich = riches;
            [strongSelf submitToAPIServer];
        } failed:^{
            STRONGSELF
            [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
            [[HUDHelper sharedInstance] tipMessage:@"上传失败" inView:strongSelf.window];
        }];
    }
}

#pragma mark - APIServer

- (void)submitToAPIServer{
    for (RichMode *mode in self.supplyRich) {
        if ([mode.type isEqualToString:@"text"]) {
            UITextView *textView = [self.view viewWithTag:mode.tagForView];
            mode.inputContent = textView.text;
        }
    }
    
    NSMutableArray *uploadContent = [RichMode turnToRichModeUpload:self.supplyRich];
    NSString *contentString       = [uploadContent mj_JSONString];
    self.demandInfo.content       = contentString;
    
    self.demandInfo.id = self.demandInfo.demandId;
    if (self.demandInfo.demandId) {
        [self doUpdate];
    }else{
        [self doPublish];
    }
}

// 更新供求
- (void)doUpdate{
    WEAKSELF
    [APIServerSdk doDemandUpdate:self.demandInfo succeed:^(id obj) {
        STRONGSELF
        [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
        [[HUDHelper sharedInstance] tipMessage:@"更新成功" inView:strongSelf.window];
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
        [[HUDHelper sharedInstance] tipMessage:@"更新失败" inView:strongSelf.window];
    }];
}

// 发布供求
- (void)doPublish{
    WEAKSELF
    [APIServerSdk doDemandPublish:self.demandInfo succeed:^(id obj) {
        STRONGSELF
        [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
        [[HUDHelper sharedInstance] tipMessage:@"发布成功" inView:strongSelf.window];
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
        [[HUDHelper sharedInstance] tipMessage:@"发布失败" inView:strongSelf.window];
    }];
}


#pragma mark - Make Component

- (void)imageDel:(UIButton *)sender{
    UIImageView *imageView = (UIImageView *)sender.superview;
    [imageView removeFromSuperview];
    
    NSInteger tag = imageView.tag;
    NSInteger index = -1;
    
    index = [self findIndexByTag:tag richArray:self.supplyRich];
    if (index != -1) {
        [self.supplyRich removeObjectAtIndex:index];
        return;
    }
    
    index = [self findIndexByTag:tag richArray:self.supplyRich];
    if (index != -1) {
        [self.supplyRich removeObjectAtIndex:index];
    }
}


static int viewTagNow = 1001;
- (RichMode *)createBlankTextRich{
    RichMode *mode = [[RichMode alloc] init];
    mode.type = @"text";
    mode.tagForView = viewTagNow ++;
    return mode;
}

- (RichMode *)createImageRichModel:(UIImage *)image{
    RichMode *mode = [[RichMode alloc] init];
    mode.type = @"image";
    mode.image = image;
    mode.width = image.size.width;
    mode.height = image.size.height;
    mode.tagForView = viewTagNow++;
    return mode;
}

- (JKTextField_Padding *)makeLinerTitleWithInput:(NSString *)title placeHolder:(NSString *)placeHolder{
    UILabel *sectionLabel          = [self makeTitleLabel:title];

    JKTextField_Padding *textField = [[JKTextField_Padding alloc] init];
    textField.borderColor          = kMainTextFieldBorderColor;
    textField.font                 = kMainTextFieldTextFontMiddle;
    textField.textColor            = kMainTextColor;
    textField.borderW              = 1;
    textField.placeholder          = placeHolder;
    textField.leftPadding          = 5;
    
    textField.myHeight             = 24;
    textField.myTop                = 5;
    textField.myLeading            = 0;
    textField.myTrailing           = 0;
    
    [self.rootLiner addSubview:sectionLabel];
    [self.rootLiner addSubview:textField];
    return textField;
}

- (UILabel *)makeTitleLabel:(NSString *)title{
    UILabel *sectionLabel      = [UILabel new];
    sectionLabel.text          = title;
    sectionLabel.font          = kMainTextFieldTextFontMiddle;
    sectionLabel.textColor     = kSecondTextColor;
    [sectionLabel sizeToFit];
    sectionLabel.myTop         = 12;
    return sectionLabel;
}

- (MyLinearLayout *)makeLinerContent:(NSString *)title{

    UILabel *sectionLabel = [self makeTitleLabel:title];
    
    MyLinearLayout *linerCotent = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    linerCotent.layer.borderColor = kMainTextFieldBorderColor.CGColor;
    linerCotent.layer.borderWidth = 1;
    linerCotent.heightSize.min(80);
    linerCotent.myLeading = 0;
    linerCotent.myTrailing = 0;
    linerCotent.wrapContentHeight = YES;
    
    [self.rootLiner addSubview:sectionLabel];
    [self.rootLiner addSubview:linerCotent];
    return linerCotent;
}

- (NSInteger)findIndexByTag:(NSInteger)tag richArray:(NSMutableArray *)array{
    __block NSInteger index = -1;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RichMode *rich = obj;
        if (rich.tagForView == tag) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (void)dealEmptyTextViewDel:(UITextView *)textView{
    NSInteger tag = textView.tag;
    if (textView.superview == self.linerContent) {
        NSInteger index = [self findIndexByTag:tag richArray:self.supplyRich];
        if (index == 0 && self.supplyRich.count == 1) {
            return;
        }
        
        if (index < self.supplyRich.count - 1) {
            [textView removeFromSuperview];
            [self.supplyRich removeObjectAtIndex:index];
            RichMode *lastMode = [self.supplyRich lastObject];
            [[self.view viewWithTag:lastMode.tagForView] becomeFirstResponder];
            return;
        }
        
        RichMode *lastMode = [self.supplyRich objectAtIndex:index - 1];
        if ([lastMode.type isEqualToString:@"image"]) {
            [self.supplyRich removeObjectAtIndex:index - 1];
            [[self.view viewWithTag:lastMode.tagForView] removeFromSuperview];
        }
        
        if ([lastMode.type isEqualToString:@"text"]) {
            [textView removeFromSuperview];
            [self.supplyRich removeObjectAtIndex:index];
            [[self.view viewWithTag:lastMode.tagForView] becomeFirstResponder];
        }
    }
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
    CGFloat h = [textView sizeThatFits:CGSizeMake(kRichSupplyWidth, CGFLOAT_MAX)].height;
    textView.myHeight = h;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location == 0 && range.length == 0 && text.length == 0) {
        [self dealEmptyTextViewDel:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.superview isEqual:self.linerContent]) {
        self.currentEdit = 1;
    }else{
        self.currentEdit = -1;
    }
}


@end
